---
layout: post
title:  "Processing a CSV file in batch with Sidekiq"
date: 2019-04-03 10:00:00
categories: ["sidekiq"]
author: "cleiviane"
---

[Sidekiq Pro](https://sidekiq.org/products/pro.html) comes with a great feature to process a collection of jobs as a batch, allowing them to be monitored as a group and executing a callback function when all the jobs are finished. This is useful when you need to load a lot of spreadsheet files into your database.  

Recently, that was the case of one of [Ombu Labs](http://ombulabs.com)' clients. They needed to upload a CSV file with over 10 thousand rows of loans data, which makes processing the file synchronously impossible because the browser will time out after a few seconds. Breaking the file into smaller ones wasn't a good idea either, because it would take an unacceptable amount of time to finish. So we decided to use the Sidekiq's batch logic.

Since Sidekiq Pro wasn't an option at the time, we had the challenge of implementing the same pattern that Sidekiq Pro uses in their Batches processing. This article will show how we did it.

<!--more-->

## Show me the code

After the user uploads the CSV file we save the data into the database and schedule one job that will schedule one background job for each row into the saved CSV file. This is necessary because the uploaded files are too big, and trying to processing them as a single file would eventually time out as well.

This is what we have in our first Job class:

```ruby
class BatchJob
  include Sidekiq::Worker

  sidekiq_options retry: true, queue: "batches", max_retries: 5

  def perform(batch_id)
    batch = Batch.find_by(id: batch_id)

    if batch
      batch.update_attribute(:status, "Processing")
      BatchProcessor.call(batch)
    end
  end
end
```

This job is retrieving the batch created during the upload and keeping track of the batch status by setting it as "Processing".

At [Ombu Labs](https://www.ombulabs.com/) we like to use the [Service Objects Pattern](https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial), so let's extract the logic to schedule all the other jobs to the `BatchProcessor` class:

```ruby
class BatchProcessor
  def self.call(batch)
    batch_rows = CSVParser.new(batch.spreadsheet)

    batch.update_column(:rows_size, batch_rows.size)

    batch_rows.each_with_index do |row, index|
      batch_row = BatchRow.new(row: index, status: "Queued", batch_id: batch.id)
      CreateLoansJob.perform_async(batch.id, batch_row.id)
    end
  end
end
```

For each of the spreadsheet row, we are creating a `BatchRow` object to keep track of each row status, row number and the associate batch id. We are doing this so we can trace back each row in case of error and we can also show the progress of the entire batch processing to the user by telling how many rows the file has, how many were successfully processed and how many have problems.

The last step is to implement the job that will actually create one loan for each row in the CSV file:

```ruby
class CreateLoansJob
  include Sidekiq::Worker

  sidekiq_options retry: true, queue: "loans", max_retries: 0

  def perform(batch_id, row_id)
    batch_row = BatchRow.find(row_id)

    batch_row.update_column(:state, "Processing")

    loan_attributes = JSON.parse(batch_row.data)

    LoanCreator.create_loan(batch_id, batch_row, loan_attributes)

    batch_row.update_column(:state, "Processed")
  end
end
```

Now the service `LoanCreator` can handle the business logic to create a loan and we are done!

## Conclusion

As we can see this pattern can be very helpful when you need to turn a big file upload into a batch background process by breaking it into several small jobs and keeping track of each job in the batch.

This approach helped us to improve the performance of the upload process for our client and allowed us to generate a report with all the rows that end up with a problem (eg. the row didn't have a required field), making possible for the user to re-upload the file after fixing all the issues.
