---
layout: post
title: "Often neglected API best practices"
date: 2019-01-30 09:00:00
reviewed: 2020-03-05 10:00:00
categories: ["best-practices", "APIs"]
author: "rdormer"
---

If you've been a web developer for any length of time at all these days, you've no doubt used at least a
few web based APIs here and there. It's possible that you've even written one (or more!) yourself.
API design is a rich topic with a lot of deep roots, but some cursory research will show a number of best
practices that public facing APIs should implement. Understanding these practices will give you a firm basis
for judging the quality of APIs as a user and consumer, and allow you to design more useful APIs when it's your turn.

<!--more-->

Over the years, I've used a _lot_ of APIs myself, and here are some best practices that I see getting short shrift:

### Versioning

Versioning an API is something that's surprisingly difficult to do well, and yet absolutely necessary. As time goes
by and your API gains more and more users, the time will come when you need to make changes to the public interface
that may break a lot of your users' existing code. Versioning allows you to neatly sidestep this problem by just
putting the breaking changes in a new version. Actually doing this, however, will need a [lot](https://restfulapi.net/versioning/) [of](https://apigee.com/about/blog/developer/common-misconceptions-about-api-versioning) [careful](https://blog.apisyouwonthate.com/api-versioning-has-no-right-way-f3c75457c0b7) [detailed](https://semver.org/) [thought](https://blog.restcase.com/restful-api-versioning-insights/). What's most important here isn't necessarily the way you choose to do it, however. What's most important is that you _bother to do it at all_.

### Return navigation information in link headers, where applicable

If you're returning paginated data, or results that are otherwise part of a large data set, it would be a good
idea to return [link headers](https://tools.ietf.org/html/rfc5988). These headers let you include navigation
links, along with type information describing their use. Including them makes your users' lives easier, and aides
in the creation of full featured navigation UIs.

### If your API is rate limited, return the current limit counters

Otherwise, you'll be forcing the developers using your API to implement their own counting logic to track the status.
They probably won't like that. As a bonus, if you ever have to change the rate limiting policy on your API, it now
becomes a breaking change for all of your users.

Avoid that headache and do your users a favor by returning rate limiting counters in the response to every rate
limited request. The headers you'll usually want to use are:

**X-Rate-Limit-Limit** - The number of requests allowed in a given period  
**X-Rate-Limit-Remaining** - The number of requests left in the current period  
**X-Rate-Limit-Reset** - Seconds until the current period elapses (may not be useful if you implement
rolling rate limit windows)

And while we're discussing rate limiting, you may also want to consider returning the appropriate error codes
when those rate limits are exceeded. **Error 429 (Too Many Requests)** is the official standard here.

### Use proper status codes

Pay close attention to what your API is doing, and what sorts of error cases it will encounter. For almost all
of the common errors that you might encounter, there's an HTTP status [_that maps directly to that particular
type of error_](https://tools.ietf.org/html/rfc7231#section-6). Use it!

There's more to this than just being pedantic, by the way. Since most developers will be interacting with HTTP
through some kind of library (like Ruby's [RestClient](https://github.com/rest-client/rest-client), for instance),
there's a good chance that the library provides support for fine grained error handling based on the specific error
code being returned. If you're not fully leveraging the HTTP status codes, then you're depriving your end users of
that functionality.

### Return structured error messages

Speaking of errors - a status code is all well and good, if it's the right status code, but additional error messages
are highly useful. The HTTP standard allows you to return a body along with any error code, so be helpful and put
additional information there. To really do it right, structure your error messages so that they can potentially
contain more than just a brief message - a JSON encoded hash will work perfectly. You can associate the error
message with the same key every time, and include additional information as needed, like so:

```
{"msg":"User quota exceeded","max_allowed":10000,"administrator_id":1234}
```

In this example you not only get a message that tells you what went wrong (you're over quota), you're also told
what your quota actually is, and the user id of the person to go bother about it. Much more useful than just a
status code or a generic error message alone.

The gold standard for an API that does this well is the [GitHub API](https://developer.github.com/v3/). Not only
do you get a structured error message with a description, you also get _a link to the relevant documentation_.

Which brings us to the next thing every good API needs:

### Documentation, Documentation, Documentation

All of the thoughtful design in the world won't mean a thing if no one knows how to use it. Document every facet
of your API - the individual endpoints, what they require, what is optional, and what they return, including errors
and headers. It's almost impossible to overdo this part. If you find yourself wondering if you should document
some aspect of your API, the answer is "Yes." Writing documentation is rarely fun, and writing it well is difficult.
The difficulty is worth it, though, because the strength of documentation alone can often be a deciding factor in whether
an API actually picks up users. One interesting option here is [Swagger](https://swagger.io/solutions/api-documentation/),
also known as the OpenAPI Specification. This standard defines an inline documentation format for specifying API endpoints
and behavior, and comes with a rich tool chain that helps to automatically generate associated code scaffolding such as
SDK skeletons and test suites. Support may vary depending on your environment, and some people have objections to the
code conventions that some of these tools enforce, but it's worth a look if you're about to write an API of your own.

These are just a few of the [many](https://blog.mwaysolutions.com/2014/06/05/10-best-practices-for-better-restful-api/), [many](https://github.com/RestCheatSheet/api-cheat-sheet#api-design-cheat-sheet), [many](https://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api)
different practices and design patterns that go into building an API that's a useful tool instead of an annoying chore.
Make sure to implement these often neglected best practices, and you'll be well on your way.
