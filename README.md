# Twitter Sentiment
Use the power of machine learning to know in an instant what people think about any topic, account, or hashtag in Twitter.
![Image](/images/screenshot1.png)
![Image2](/images/screenshot2.png)
# Features
*  We use a machine learning Natural Language Processing (NLP) model to predict if the sentiment of a tweet was Neutral, Positive or Negative.
* We fetch the last 100 tweets about your search and obtain an overall score of them
* After obtaining the overall score the user gets the result on screen.
# How to Get Sarted
1. Install the latest version of Xcode from the Mac AppStore.
2. Install  [CocoaPods](https://cocoapods.org/)  to your machine.
3. Fork the project and clone it to your local machine.
4. In the terminal, change directory to the one that contains the project.
5. Run  `pod install`  to be able to build locally.
6. Create an account as a twitter developer and obtain your own consumer API key and consumer secret API key.
7. Change the strings in the swifter constant using your own Twitter API keys.
# If having problems with Swifter
Delete the Swifter file in the files inspector and replace it with the one from the clone of the git repository:  [Swifter](https://github.com/mattdonnelly/Swifter) then embed the iOS.framework.
