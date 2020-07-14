# Welcome

This repository contains starter code for a technical assessment. The challenges can be done at home before coming in to discuss with the Bark team or can be done as a pairing exercise at the Bark office. Either way, we don't expect you to put more than an hour or two into coding. We recommend forking the repository and getting it running before starting the challenge if you choose the pairing approach.

# Set up

Fork this repository and clone locally

You'll need [ruby 2.2.4](https://rvm.io/rvm/install) and [rails 5](http://guides.rubyonrails.org/getting_started.html#installing-rails) installed.

Run `bundle install`

Initialize the data with `rake db:reset`

Run the specs with `rspec`

Run the server with `rails s`

View the site at http://localhost:3000

# TODO

- [ ] Add pagination to index page, to display 5 dogs per page

- [ ] Add the ability to for a user to input multiple dog images on an edit form or new dog form

- [x] Associate dogs with owners

  - A.Haas notes: I currently have this as a required relationship so if you try and edit a "stray" dog or creating a new dog while not signed in then it will fail

- [ ] Allow editing only by owner

- [ ] Allow users to like other dogs (not their own)

- [ ] Allow sorting the index page by number of likes in the last hour

- [ ] Display the ad.jpg image (saved at app/assets/images/ad.jpg) after every 2 dogs in the index page, to simulate advertisements in a feed.
