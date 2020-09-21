//
//  ContentView.swift
//  TweetScanner
//
//  Created by user177767 on 9/18/20.
//

import SwiftUI
import SwifteriOS
import SwiftyJSON
import CoreML

struct ContentView: View {
    
    @State var searchText = ""
    @State var bottomState = false
    
    @State var positiveTweets = 0
    @State var neutralTweets = 0
    @State var negativeTweets = 0
    
    let tweetCount = 100
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "your Twitter API key", consumerSecret: "your Twitter API secret key")
    
    var body: some View {
        
        ZStack {
            
            Color(#colorLiteral(red: 0.262745098, green: 0.7098039216, blue: 0.6274509804, alpha: 1))
                .edgesIgnoringSafeArea(.all)
                .opacity(0.85)
            
            VStack(spacing: 30) {
                
                HStack {
                    Circle()
                        .frame(width: 100, height: 100)
                    
                    Spacer()
                    
                    VStack {
                        Text("Analysis outcome")
                            .font(.title3)
                            .padding(.bottom)
                        Text("\(positiveTweets) positives out of 100")
                            .font(.subheadline)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .background(Color(#colorLiteral(red: 0.9803921569, green: 0.2666666667, blue: 0.5490196078, alpha: 1)).opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 20)
                
                HStack {
                    
                    CountView(title: "Positive", countTweet: $positiveTweets)
                    CountView(title: "Neutral", countTweet: $neutralTweets)
                    CountView(title: "Negative", countTweet: $negativeTweets)
                    
                }
                
    
                
                TextField("Search", text: $searchText, onCommit:  {
                    positiveTweets = 0
                    neutralTweets = 0
                    negativeTweets = 0
                    fetchTweets(with: searchText)
                    endEditing()
                })
                    .padding()
                    .frame(width: 200, height: 50)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .frame(width: 220, height: 70)
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 29, style: .continuous))
                
                Spacer()
                
                Button("Analyse", action: {
                    
                    positiveTweets = 0
                    neutralTweets = 0
                    negativeTweets = 0
                    
                    fetchTweets(with: searchText)
                    
                    endEditing()
                    
                }
                )
                .font(.system(size: 25, weight: .semibold, design: .default))
                .frame(width: 150, height: 70)
                .foregroundColor(.white)
                .background(Color(#colorLiteral(red: 0.2862745098, green: 0.1137254902, blue: 0.5333333333, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0.0, y: 15)
                .offset(y: -57)
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 600)
            .padding(.horizontal, 30)
            .padding(.vertical, 50)
            
        }
        
    }
    
    func endEditing() {
        //Used because we only have one Scene
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    func fetchTweets(with text: String) {

            swifter.searchTweet(using: text, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in

                var tweets = [TweetSentimentClassifierInput]()

                for i in 0..<self.tweetCount {

                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }

                self.makePrediction(with: tweets)

            }) { (error) in
                print("Error with the Twitter API Request: \(error)")
            }
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
            
      do {
          
          let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
          
          var sentimentScore = 0
          
          for inference in predictions {
              
              switch inference.label {
              case "Pos":
                  positiveTweets += 1
              case "Neg":
                  negativeTweets += 1
              case "Neutral":
                neutralTweets += 1
              default:
                  sentimentScore += 0
              }
              
          }
          
      } catch {
          print("Error making classifications: \(error)")
      }
            
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CountView: View {
    
    var title: String
    @Binding var countTweet: Int
    
    var body: some View {
        Rectangle()
            .background(Color(#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)))
            .frame(width: 100, height: 120)
            .overlay(
                VStack(spacing: 30) {
                    Text(title)
                    Text("\(countTweet)")
                }
                .foregroundColor(.white)
            )
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
    }
}
