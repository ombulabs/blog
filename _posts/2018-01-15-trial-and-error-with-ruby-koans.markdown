---
layout: post
title: "Trial and Error with Ruby Koans"
date: 2018-01-24
categories: ["Ruby", "Learning"]
author: "emily"
---

After reading introductory primers and watching instructional videos for beginners learning [Ruby](https://www.ruby-lang.org/en), I needed a program that would allow me to test out Ruby concepts for myself. I began practicing [**Ruby Koans**](http://rubykoans.com), **a testing-based program that runs through a variety of Ruby concepts in a trial and error fashion**.

<!--more-->

Instead of providing problems and requiring that the user figure out the answers, the Koans provide answers to various tests and, using *assert_equal*, require the user to fill in the blanks and correct the code until the program runs without errors.

The first exercises run through Ruby concepts including **[strings](https://github.com/ercohen14/ruby-koans/blob/master/about_strings.rb)**, **[arrays](https://github.com/ercohen14/ruby-koans/blob/master/about_arrays.rb)** and **[methods](https://github.com/ercohen14/ruby-koans/blob/master/about_methods.rb)**.

The exercise [About Objects](https://github.com/ercohen14/ruby-koans/blob/master/about_objects.rb) was particularly useful for me as a Junior Developer. I had heard time and again that [*"in Ruby, everything is an object”*](https://launchschool.com/books/oo_ruby/read/the_object_model), however I didn’t understand what *“being an object”* actually entailed. This exercise went through what it means to be an object, specifying that although many items are objects, no two objects are ever exactly the same.

    def test_clone_creates_a_different_object
      obj = Object.new
      copy = obj.clone

      assert_equal true, obj           != copy
      assert_equal true, obj.object_id != copy.object_id
    end

After the Ruby concept exercises, the Koans culminate in a series of projects that allow the user to apply what they have learned about each concept to complete more complex exercises. One that proved useful to me was the [About Triangle Project](https://github.com/ercohen14/ruby-koans/blob/master/about_triangle_project.rb).

This exercise gives the user side lengths of three different triangles, and asks the user to write code to test whether each triangle is equilateral, isosceles or scalene.


      class AboutTriangleProject < Neo::Koan
        def test_equilateral_triangles_have_equal_sides
          assert_equal :equilateral, triangle(2, 2, 2)
          assert_equal :equilateral, triangle(10, 10, 10)
        end

        def test_isosceles_triangles_have_exactly_two_sides_equal
          assert_equal :isosceles, triangle(3, 4, 4)
          assert_equal :isosceles, triangle(4, 3, 4)
          assert_equal :isosceles, triangle(4, 4, 3)
          assert_equal :isosceles, triangle(10, 10, 2)
        end

        def test_scalene_triangles_have_no_equal_sides
          assert_equal :scalene, triangle(3, 4, 5)
          assert_equal :scalene, triangle(10, 11, 12)
          assert_equal :scalene, triangle(5, 4, 2)
        end
      end

The answer combines a number of basic [Ruby operators](https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Operators), including ==, && and ||, and is a simple exercise to begin thinking about the ways that Ruby can solve more complex problems.

**I would highly recommend Ruby Koans** to any developer who has some knowledge of Ruby and test-driven development and is looking to learn more.

In our Junior Developer Training Path at OmbuLabs, we typically complete the Ruby Koans after reading a Ruby primer book, such as [The Well-Grounded Rubyist](https://www.manning.com/books/the-well-grounded-rubyist-second-edition), to get an understanding of the fundamentals of Ruby. What steps did you take to learn to code? Do you have a great Junior Developer Training Path to recommend? Let us know!
