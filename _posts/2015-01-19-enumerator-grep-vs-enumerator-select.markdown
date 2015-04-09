---
layout: post
title:  "Enumerable#grep vs Enumerable#select"
date:   2015-04-09 11:37:00
categories: ["ruby", "benchmark"]
---

Often, `Enumerable#select` is the chosen method to obtain elements from an
Array for a given block. Without thinking twice, we may be doing more work than
necessary by not taking advantage of another method from the Enumerable module,
`Enumerable#grep`.

`Enumerable#grep` can not always be used instead of `Enumerable#select`, but
when it can, `#grep` provides better readability and a small speed improvement
over `#select`.

See the benchmark below for example, which uses the class matcher for `#grep`:

```ruby
2.1.2 :041 > a = (1..100000).map { rand(100000) }
2.1.2 :042 > b = (1..100000).map { rand(100000).to_s }
2.1.2 :043 > c = a + b
2.1.2 :044 > Benchmark.bm(10) do |b|
2.1.2 :045 >   b.report("select")    { c.select { |x| x.to_i == x } }
2.1.2 :046?>   b.report("grep")      { c.grep(Integer) }
2.1.2 :047?> end
                 user     system      total        real
select       0.070000   0.000000   0.070000 (  0.064458)
grep         0.020000   0.000000   0.020000 (  0.023958)

2.1.2 :048 > c.select { |x| x.to_i == x } == c.grep(Integer)
 => true
```

You can also see its power when using Regexp patterns, which is not only faster
but also less verbose, which is enough of a win to favor it over `#select`:

```ruby
2.1.2 :049 > a = (1..100000).map { (65 + rand(26)).chr }
2.1.2 :050 > b = (1..100000).map { rand(10).to_s }
2.1.2 :051 > c = a + b
2.1.2 :052 > Benchmark.bm(10) do |b|
2.1.2 :053 >   b.report("select")    { c.select{|x| /^\d*$/ === x} }
2.1.2 :054?>   b.report("grep")      { c.grep(/^\d*$/) }
2.1.2 :055?> end
                 user     system      total        real
select       0.020000   0.000000   0.020000 (  0.021058)
grep         0.020000   0.000000   0.020000 (  0.012626)
```

There are some pretty good use cases for `#grep`, and one last thing worth
keeping in mind: `#grep` can take a second parameter, which acts
as `#map` does and reads very nicely. For example:

```ruby
2.1.2 :056 > hello = ['Hello', 'ello', 'llo', 'lo', 'o']
2.1.2 :057 > hello.select { |x| /[A-Z]\w+/ === x }.map(&:downcase)
 => ["hello"]
2.1.2 :058 > hello.grep(/[A-Z]\w+/, &:downcase)
 => ["hello"]
```
