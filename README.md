# Twitter
# Project 2 - *Twitter*

**Twitter** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **20** hours spent in total

## User Stories

The following **core** features are completed:

**A user should**

- See an app icon in the home screen and a styled launch screen
- Be able to log in using their Twitter account
- See at latest the latest 20 tweets for a Twitter account in a Table View
- Be able to refresh data by pulling down on the Table View
- Be able to like and retweet from their Timeline view
- Only be able to access content if logged in
- Each tweet should display user profile picture, username, screen name, tweet text, timestamp, as well as buttons and labels for favorite, reply, and retweet counts.
- Compose and post a tweet from a Compose Tweet view, launched from a Compose button on the Nav bar.
- See Tweet details in a Details view
- App should render consistently all views and subviews in recent iPhone models and all orientations

The following **stretch** features are implemented:

**A user could**

- Like/retweet from Details view. Doing so will increment the count. Changes reflected on Details and Timeline view. 
- Unlike/un-retweet by tapping liked/retweeted Tweet button. Doing so will decrement the count. 
- Clickable Links in Tweets - Tweets that include links allow a user to click on them.
- Only create tweets that are 280 characters or less. Character limit incorporated so user is stopped from typing more than allowed limit.
- See how many available characters are left while they compose a tweet.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Working with delegates
2. Best ways to go about doing constraints

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![](https://github.com/architasingh/Twitter/blob/main/twitterGIF.gif)


## Notes

The auto-layout portion was difficult because it took time getting used to creating constraints and formatting the content in the desired format.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [2022] [Archita Singh]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
