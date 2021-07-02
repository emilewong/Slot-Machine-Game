//
//  ContentView.swift
//  Slot Machine Game
//
//  Created by Emile Wong on 30/6/2021.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 500
    @State private var initialNumberOfCoins: Int = 500
    @State private var betAmount: Int = 10
    @State private var reelItems: Array = [0, 1, 2]
    @State private var showInfoView: Bool = false
    @State private var isBet20Active: Bool = false
    @State private var isBet10Active: Bool = true
    @State private var showingModal: Bool = false
    @State private var animatingSymbols: Bool = false
    @State private var animatingModal: Bool = false
    
    // MARK: - FUNCTIONS
    
    func spinReels() {
        reelItems = reelItems.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func checkWinning() {
        if reelItems[0] == reelItems[1] && reelItems[1] == reelItems[2] && reelItems[0] == reelItems[2] {
            // PLAYER WINS
            playWins()
            
            // NEW HIGH SCORE
            if coins > highscore {
                newHighScore()
            }
            
        } else {
            // PLAYER LOOSES
            playerLoses()
        }
    }
    
    func playWins() {
        coins += betAmount * 10
        playSound(sound: "win", type: "mp3")
    }
    
    func newHighScore() {
        highscore = coins
        UserDefaults.standard.setValue(highscore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isBet20Active = true
        isBet10Active = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmount = 10
        isBet10Active = true
        isBet20Active = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func isGameOver() {
        if coins < 0 {
            self.showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
        
    }
    
    func resetGame() {
        self.highscore = 0
        coins = initialNumberOfCoins
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
        
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // MARK: - BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            // MARK: - INTERFACE
            VStack(alignment: .center, spacing: 5) {
                // HEADER
                LogoView()
                
                Spacer()
                
                // SCORE
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                // SLOT MACHINE
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - REEL #1
                    ZStack {
                        ReelView()
                        
                        Image(symbols[reelItems[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbols ? 1 : 0)
                            .offset(y: animatingSymbols ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...1.1)))
                            .onAppear(perform: {
                                self.animatingSymbols.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            })
                    }
                    
                    HStack{
                        // MARK: - REEL #2
                        ZStack {
                            ReelView()
                            
                            Image(symbols[reelItems[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbols ? 1 : 0)
                                .offset(y: animatingSymbols ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.5...1.1)))
                                .onAppear(perform: {
                                    self.animatingSymbols.toggle()
                                })
                        }
                        
                        Spacer()
                        
                        // MARK: - REEL #3
                        ZStack {
                            ReelView()
                            
                            Image(symbols[reelItems[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbols ? 1 : 0)
                                .offset(y: animatingSymbols ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.5...1.1)))
                                .onAppear(perform: {
                                    self.animatingSymbols.toggle()
                                })
                        }
                    }
                    
                    // MARK: - SPIN BUTTON
                    Button(action: {
                        // 1. SET THE DEFAULT STATE: NO ANIMATION
                        withAnimation {
                            self.animatingSymbols = false
                        }
                        // 2. SPIN THE REELS
                        spinReels()
                        
                        // 3. SET THE NEW STATE: WITH ANIMATION
                        withAnimation {
                            self.animatingSymbols = true
                        }
                        
                        // 4. CHECK WINNING
                        checkWinning()
                        
                        // 5. GAME OVER
                        isGameOver()
                        
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                }
                
                // FOOTER
                Spacer()
                
                
                HStack {
                    // MARK: - BET 20
                    HStack {
                        Button(action: {
                            activateBet20()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isBet20Active ? Color("ColorYellow") : Color.white)
                                .font(.system(.title, design: .rounded))
                                .padding(.vertical, 5)
                                .frame(width: 90)
                                .shadow(color: Color("ColorTransparentBlack"), radius: 0, x: 0, y: 3)
                        }) //: BUTTON
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isBet20Active ? 0 : 30)
                            .opacity(isBet20Active ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    } //: HSTACK
                    
                    Spacer()
                    
                    // MARK: - BET 10
                    HStack {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isBet10Active ? 0 : -30)
                            .opacity(isBet10Active ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            activateBet10()
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isBet10Active ? Color("ColorYellow") : Color.white)
                                .font(.system(.title, design: .rounded))
                                .padding(.vertical, 5)
                                .frame(width: 90)
                                .shadow(color: Color("ColorTransparentBlack"), radius: 0, x: 0, y: 3)
                        }) //: BUTTON
                        .modifier(BetCapsuleModifier())
                        
                    } //: HSTACK
                } //: HSTACK
                
            } //: VSTACK
            .overlay(
                // MARK: - RESET BUTTON
                Button(action: {
                    resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                    
                })
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            // MARK: - INFO BUTTON
            .overlay(
                Button(action: {
                    self.showInfoView.toggle()
                }, label: {
                    Image(systemName: "info.circle")
                    
                })
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK: - POPUP
            if $showingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .edgesIgnoringSafeArea(.all)
                    
                    //MODAL
                    VStack(spacing: 0) {
                        // TITLE
                        Text("Game Over".uppercased())
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        // MESSAGE
                        Image("gfx-seven-reel")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 72)
                        
                        Text("Bad luck! You lost all your coins. \nlet's play again!")
                            .font(.system(.body, design: .rounded))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.gray)
                            .layoutPriority(1)
                        
                        Spacer()
                        
                        // BUTTON
                        Button(action: {
                            self.showingModal = false
                            self.animatingModal = false
                            self.activateBet10()
                            self.coins = initialNumberOfCoins
                        }, label: {
                            Text("New Game".uppercased())
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.semibold)
                                .accentColor(Color("ColorPink"))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(minWidth: 128)
                                .background(
                                    Capsule()
                                        .strokeBorder(lineWidth: 1.75)
                                        .foregroundColor(Color("ColorPink"))
                                )
                                
                        })
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModal = true
                    })
                }
            }
            
        } //: ZSTACK
        .sheet(isPresented: $showInfoView, content: {
            InfoView()
        })
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
