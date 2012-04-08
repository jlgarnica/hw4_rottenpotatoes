# Add a declarative step here for populating the DB with movies.

Then /the director of "(.+)" should be "(.+)"/ do |e1,e2|
  tmp = Movie.find_by_title e1
  tmp.director.should == e2
end


Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    movie_object = Movie.find_by_title movie[:title]
    if (!movie_object)
      Movie.create!(movie)
    else
      movie_object.update_attributes movie
    end
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  assert true
end

Then /I should see the following movies/ do |movies_table|
  movies_table.hashes.each do |movie|
    step %{I should see "#{movie[:title]}"}
  end
end

Then /I should not see the following movies/ do |movies_table|
  movies_table.hashes.each do |movie|
    step %{I should not see "#{movie[:title]}"}
  end
end

Then /I should see no movies/ do
  all("table#movies tbody tr").length.should == 0
end


Then /I should see all movies/ do
  all("table#movies tbody tr").length.should == Movie.all.length
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.

  e1_index = page.body.index e1
  e2_index = page.body.index e2
  assert (e1_index and e2_index and e1_index < e2_index)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(%r{,\s*}).each do |rating|
    if uncheck
      uncheck "ratings[#{rating}]"
    else
      check "ratings[#{rating}]"
    end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end
