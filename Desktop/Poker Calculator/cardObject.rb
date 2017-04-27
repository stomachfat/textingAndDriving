module CalculatorsForOneHandAndCommunity
    def getAllFlushSuitedCards(arrayOfCards, suit)
        allFlushSuitedCards = []
        arrayOfCards.each do |card|
            allFlushSuitedCards << card if card.suit == suit
        end
        #puts "the type of XXX " + allFlushSuitedCards.class.to_s
        return allFlushSuitedCards
    end
            
    def hasStraight?(arrayOfCards = @handAndCommunity)
        hasStraight = false
        cardNumbers = []
        
        arrayOfCards.each do |card|
            cardNumbers << card.number()
        end
        cardNumbers.sort!
        #puts cardNumbers.to_s
        
        cardNumbers.each do |number|
            catch(:notStraight) do
                for i in 1..4
                    if not cardNumbers.include?(number+i)
                        throw(:notStraight)
                    end
                end
                hasStraight= true
            end
        end
        
        if cardNumbers.include?(1) #includes ace, then check for ace high straight
            catch(:notAceHighStraight) do
                for i in 10..13
                    if not cardNumbers.include?(i)
                        throw(:notAceHighStraight)
                    end
                end
                hasStraight = true
            end
        end
        
        #puts "hasStraight: " + hasStraight.to_s
        return hasStraight
    end
    
    def getFlushSuit(arrayOfCards = @handAndCommunity)
        flushSuit = nil
        countSuits = Hash.new(0)
        
        arrayOfCards.each do |card|
            countSuits[card.suit] += 1
        end
        
        countSuits.each do |suit, count|
            flushSuit = suit if count >= 5
        end
        return flushSuit
    end
    
    def hasFlush?(arrayOfCards = @handAndCommunity)
        hasFlush = false
        
        return true if getFlushSuit(arrayOfCards) != nil
        return hasFlush
    end
    
   
    
    def hasStraightFlush?(arrayOfCards = @handAndCommunity)
        return false if !hasFlush?()
        flushSuit = getFlushSuit(arrayOfCards)
        allFlushSuitedCards = nil
        allFlushSuitedCards = getAllFlushSuitedCards(arrayOfCards, flushSuit)
        return hasStraight?(allFlushSuitedCards)
    end
    
    def getMultipleOfAKind(arrayOfCards)
        multipleOfAKind = Hash.new(0)
        
        arrayOfCards.each do |card|
            multipleOfAKind[card.number] += 1
        end
        
        multipleOfAKind
    end
    
    def hasFourOfAKind?(arrayOfCards=@handAndCommunity)
        hasFourOfAKind = false
        multipleOfAKind = getMultipleOfAKind(arrayOfCards)
        
        
        if multipleOfAKind.key(4) != nil
            hasFourOfAKind = true
        end
        return hasFourOfAKind
    end
    
    def hasFullHouse?(arrayOfCards = @handAndCommunity)
        multipleOfAKind = getMultipleOfAKind(arrayOfCards)
        
        if multipleOfAKind.key(3) != nil && multipleOfAKind.key(2) != nil
            return true
        end
        return false
    end
    
    def hasThreeOfAKind?(arrayOfCards = @handAndCommunity)
        multipleOfAKind = getMultipleOfAKind(arrayOfCards)
        
        if (multipleOfAKind.key(3) != nil && !hasFourOfAKind?() && !hasFullHouse?())
            return true
        end
        return false
    end
    
    def hasTwoPair?(arrayOfCards = @handAndCommunity)
        multipleOfAKind = getMultipleOfAKind(arrayOfCards)
        countPairs = 0
        if hasFullHouse?() || hasFourOfAKind?()
            return false
        end
        
        multipleOfAKind.each do |number, frequency|
            countPairs += 1 if frequency >= 2
        end
        if countPairs >= 2
            return true
        else
        return false
        end
    end
    
    def hasOnePair?(arrayOfCards = @handAndCommunity)
        multipleOfAKind = getMultipleOfAKind(arrayOfCards)
        
        if multipleOfAKind.key(2) != nil && !hasFourOfAKind?() && !hasFullHouse?() && !hasTwoPair?()
            return true
        end
        return false
    end
    
    public
    def detectMadeHand(community)
        madeHand = nil
        @handAndCommunity = @hand + community.passCommunityCards
        
        #handAndCommunity.each do |card|
        #    puts card.showCard() 
        #end
        if hasStraightFlush?()
            madeHand = "straightFlush"
            #puts "has A Straight Flush!"
        elsif hasFourOfAKind?()
            madeHand = "fourOfAKind"
            #puts "has Four of A  Kind!"
        elsif hasFullHouse?()
            madeHand = "fullHouse"
            #puts "has Full House"
        elsif hasFlush?()
            madeHand = "flush"
            #puts "has Flush"
        elsif hasStraight?()
            madeHand = "straight"
            #puts "has straight"
        elsif hasThreeOfAKind?()
            madeHand = "threeOfAKind"
            #puts "has three of a kind"
        elsif hasTwoPair?()
            madeHand = "twoPair"
            #puts "has two Pair"
        elsif hasOnePair?()
            madeHand = "onePair"
            #puts "has one Pair"
        else #hasHighCard
            madeHand = "highCard"
            #puts "has high Card"
        end
        
        findBestHand(@handAndCommunity, madeHand)
        return madeHand
    end
    
    def findBestStraight(arrayOfCards = @handAndCommunity)
        bestHand = []
        cardNumbers = []
        
        arrayOfCards.each do |card|
            cardNumbers << card.number()
        end
        cardNumbers.sort!
        cardNumbers.reverse!
        
        if cardNumbers.include?(1) #includes ace, then check for ace high straight
            catch(:notAceHighStraight) do
                for i in 10..13
                    if not cardNumbers.include?(i)
                        throw(:notAceHighStraight)
                    end
                end
                bestHand << arrayOfCards.find {|card| card.number == 1}
                for j in 0...4
                     bestHand << arrayOfCards.find {|card| card.number == (13-j) }
                end
                return bestHand
            end
        end
        
        highCardOfStraight = nil
        cardNumbers.each do |number|
            catch(:notStraight) do
                highCardOfStraight = number
                for i in 1..4
                    if not cardNumbers.include?(number-i)
                        throw(:notStraight)
                    end
                end
                for j in 0...5
                    bestHand << arrayOfCards.find {|card| card.number == (highCardOfStraight-j)}
                end
                return bestHand
            end
        end
        
        return bestHand
    end
    
    def findBestStraightFlush(arrayOfCards = @handAndCommunity)
        bestHand = []
        allFlushSuitedCards= []
        allFlushSuitedCards = getAllFlushSuitedCards(arrayOfCards, getFlushSuit(arrayOfCards))
        bestHand = findBestStraight(allFlushSuitedCards)
        
    end
    
    def getHighestSet(arrayOfCards, setSize, notThisCardNumber = [])
        highestSet = []
        
        if not notThisCardNumber.include?(1)
            frequency = arrayOfCards.select {|card| card.number == 1}
            if frequency.length() == setSize
                highestSet = arrayOfCards.select {|card| card.number == 1}
                return highestSet
            end
        end
        
        for i in 0...12
            if not notThisCardNumber.include?(13-i)
                frequency = arrayOfCards.select {|card| card.number == 13-i}
                if frequency.length() == setSize
                    highestSet = arrayOfCards.select {|card| card.number == 13-i}
                    return highestSet
                end
            end
        end
        
        return highestSet
    end
    
    def findBestFourOfAKind(arrayOfCards = @handAndCommunity)
        bestHand = []
        fourOfAKindNumber = nil
        
        
        bestHand += getHighestSet(arrayOfCards, 4)
        fourOfAKindNumber = bestHand[0].number
        bestHandContains = [fourOfAKindNumber]
        bestHand += getHighestSet(arrayOfCards, 1, bestHandContains)
        
        return bestHand
    end
    
    def findBestFullHouse(arrayOfCards)
        bestHand = []
        bestHand += getHighestSet(arrayOfCards, 3)
        threeOfAKindNumber = bestHand[0].number
        bestHandContains = [threeOfAKindNumber]
        bestHand += getHighestSet(arrayOfCards, 2, bestHandContains)
        return bestHand
    end
    
    def findBestFlush(arrayOfCards = @handAndCommunity)
        bestHand = []
        flushSuit = getFlushSuit(arrayOfCards)
        allFlushSuitedCards = getAllFlushSuitedCards(arrayOfCards, flushSuit)
        bestHandContains = []
        
        5.times do
            bestHand += getHighestSet(allFlushSuitedCards, 1, bestHandContains)
            bestHandContains << bestHand[bestHand.length-1].number
        end
        
        return bestHand
    end
    
    def findBestThreeOfAKind(arrayOfCards = @handAndCommunity)
        bestHand = []
        bestHandContains = []
        bestHand += getHighestSet(arrayOfCards, 3)
        bestHandContains << bestHand[0].number
        
        2.times do
            bestHand += getHighestSet(arrayOfCards, 1, bestHandContains)
            bestHandContains << bestHand[bestHand.length() -1].number
        end
            
        return bestHand
    end
    
    def findBestTwoPair(arrayOfCards = @handAndCommunity)
        bestHand =[]
        bestHandContains = []
        
        2.times do
            bestHand += getHighestSet(arrayOfCards, 2, bestHandContains)
            bestHandContains << bestHand[bestHand.length() -1].number
        end
        bestHand += getHighestSet(arrayOfCards, 1, bestHandContains)
        
        return bestHand
    end
    
    def findBestOnePair(arrayOfCards = @handAndCommunity)
        bestHand =[]
        bestHandContains = []
        
        bestHand += getHighestSet(arrayOfCards, 2, bestHandContains)
        bestHandContains << bestHand[bestHand.length() -1].number
        
        3.times do
            bestHand += getHighestSet(arrayOfCards, 1, bestHandContains)
            bestHandContains << bestHand[bestHand.length() -1].number
        end
        
        return bestHand
    end
    
    def findBestHighCard(arrayOfCards = @handAndCommunity)
        bestHand =[]
        bestHandContains = []
        
        5.times do
                bestHand += getHighestSet(arrayOfCards, 1, bestHandContains)
            bestHandContains << bestHand[bestHand.length() -1].number
        end
        
        return bestHand
    end
        
    
    def findBestHand(arrayOfCards = @handAndCommunity, madeHand)
        bestHand = nil
        case madeHand
        when "straightFlush"
            bestHand = findBestStraightFlush(arrayOfCards)
        when "fourOfAKind"
            bestHand = findBestFourOfAKind(arrayOfCards)
        when "fullHouse"
            bestHand = findBestFullHouse(arrayOfCards)
        when "flush" 
            bestHand = findBestFlush(arrayOfCards)
        when "straight"
            bestHand = findBestStraight(arrayOfCards)    
        when "threeOfAKind"
            bestHand = findBestThreeOfAKind(arrayOfCards)
        when "twoPair"
            bestHand = findBestTwoPair(arrayOfCards)
        when "onePair"
            bestHand = findBestOnePair(arrayOfCards)
        else #"highCard"
            bestHand = findBestHighCard(arrayOfCards)
        end
        return bestHand
    end
end

module CalculatorsForTwoHands
    include CalculatorsForOneHandAndCommunity
    
    HANDRANKINGS = Hash.new()
    HANDRANKINGS["straightFlush"] = 9
    HANDRANKINGS["fourOfAKind"] = 8
    HANDRANKINGS["fullHouse"] = 7
    HANDRANKINGS["flush"] = 6
    HANDRANKINGS["straight"] = 5
    HANDRANKINGS["threeOfAKind"] = 4
    HANDRANKINGS["twoPair"] = 3
    HANDRANKINGS["onePair"] = 2
    HANDRANKINGS["highCard"] = 1
    
    def compareSameTypeOfHand(bestHandMade1, bestHandMade2)
        for i in 0...5
            if bestHandMade1[i].number != bestHandMade2[i].number
                if bestHandMade1[i].number == 1 #he has the ace kicker
                    return 1
                elsif bestHandMade2[i].number == 1
                    return -1 
                elsif bestHandMade1[i].number > bestHandMade2[i].number
                    return 1
                elsif  bestHandMade1[i].number < bestHandMade2[i].number
                    return -1
                else # bestHandMade1[i].number = bestHandMade2[i].number
                    return 0
                end
            end
        end
    end
    
    def compareTwoHands(community, hand1, hand2)
        if HANDRANKINGS[hand1.detectMadeHand(community)] > HANDRANKINGS[hand2.detectMadeHand(community)]
            #puts "hand1 wins"
            return 1
        elsif HANDRANKINGS[hand1.detectMadeHand(community)] < HANDRANKINGS[hand2.detectMadeHand(community)]
            #puts "hand2 wins"
            return -1
        else #they tie: we have to determine a tie breaker
            bestHandMade1 = findBestHand(community.community + hand1.hand, hand1.detectMadeHand(community))
            bestHandMade2 = findBestHand(community.community +  hand2.hand, hand2.detectMadeHand(community))
            case compareSameTypeOfHand(bestHandMade1, bestHandMade2)
            when 1
                #puts "hand1 wins"
                return 1
            when -1
                #puts "hand2 wins"
                return -1
            else #0
                #puts "wow a gigantic tie"
                return 0
            end
        end
    end
    
    def winningHand(community, *hands) #needs to be tested
        
        bestHand = hands[1]
        hands.each do |hand|
            if compareTwoHands(community, bestHand, hand) == -1
                bestHand = hand
            end
        end
            
        return bestHand
    end
end

module MathCalculators
    def factorial(n)
        if n == 0 
            return 1
        else 
            return n*factorial(n-1)
        end
    end
end


module StatiticalCalculators
    include CalculatorsForTwoHands
    include MathCalculators
    
=begin
this Does not remove ordering of cards in hands, that is AH 8H is not the same as 8H AH. We account for that
=end
    def isInPile?(crrtCard, pile)
        return false if pile == nil
        return true if crrtCard == nil
        pile.each do |card|
            if card.number == crrtCard.number && card.suit ==crrtCard.suit
                return true
            end
        end
        return false
    end

    def generateAllHandsThatBeatMine(community, myHand, inPlay) 
        arrayOfBetterHands = []
        for number1 in 1..13
            for suit1 in 0...4
                crrtCardsInPlay = community.community + myHand.hand
                #puts "crrtCardsInPlay are:" + crrtCardsInPlay.to_s
                checkCard1 = Card.new(number1, suit1)
                if not isInPile?(checkCard1, crrtCardsInPlay)
                    card1 = checkCard1
                    crrtCardsInPlay += [card1]
                    for number2 in 1..13
                        for suit2 in 0...4
                        checkCard2 = Card.new(number2, suit2)
                        if not crrtCardsInPlay.include?(checkCard2)
                            if checkCard2.number != card1.number || checkCard2.suit != card1.suit
                                card2 = checkCard2
                                betterHand = Hand.new(card1, card2)
                                if compareTwoHands(community, myHand, betterHand) == -1
                                    arrayOfBetterHands << betterHand
                                end
                            end
                        end
                        end
                    end
                end
            end
        end
        return arrayOfBetterHands
    end
    
    def countPossibleCardCombinations(inPlay, cardSetSize)
        playableCards = 52 - inPlay.length
        #puts "the inPlay.length is: " + inPlay.length.to_s
        #puts "the number of playable cards: " + playableCards.to_s
        numberOfPossibleCombinations = 1
        #puts "the card set size is : " + cardSetSize.to_s
        cardSetSize.times do
            numberOfPossibleCombinations *= playableCards
            playableCards -=1
        end
        return numberOfPossibleCombinations
    end
    
    def winningHeadsUpPercentageAfterRiver(community, myHand)
        inPlay = community.community + myHand.hand
        arrayOfBetterHands = generateAllHandsThatBeatMine(community, myHand, inPlay)
        numberOfBetterHands = arrayOfBetterHands.length
        puts "number of Better Hands " + numberOfBetterHands.to_s
        inPlay = community.community + myHand.hand #HUGE BUG: separate theoretical cards generate and real cards generated
        possibleNumberOfHands = countPossibleCardCombinations(inPlay, 2)
        puts "possibleNumberof Hands " + possibleNumberOfHands.to_s
        percentageOfLosing = numberOfBetterHands.to_f/possibleNumberOfHands
        return (1.00 - percentageOfLosing).round(4)*100
    end
end




class Card 
    @@inPlay = []
    
    def initialize(number = nil, suit = nil)
        card = [number, suit]
        @number = number
        @suit = suit
        card = generateCard() if card == [nil, nil]
        @number ||= card[0]
        @suit ||= card[1] 
        @@inPlay << card
    end
    
    def number
        @number
    end
    def suit
        @suit
    end
    
    public
    def generateCard()
        crrt_card = nil
        until isInDeck?(crrt_card)
            card = rand(52).floor
            number = (card % 13) + 1
            suit = (card - (number - 1))/13
            crrt_card = [number, suit]
        end
        return crrt_card
    end
    
    public
    def isInDeck?(crrt_card)
        return false if crrt_card == nil
        
        @@inPlay.each do |card|
            return false if crrt_card == card
        end
        return true
    end
    
    public 
    def showCard()
        cardNumber = @number
        cardSuit = @suit
        
        case cardNumber
        when 2..10
            #remains the same
        when 1
            cardNumber = "A"
        when 11
            cardNumber = "J"
        when 12 
            cardNumber = "Q"
        when 13
            cardNumber = "K"
        end
        
        case cardSuit
        when 0
            cardSuit = "H"
        when 1
            cardSuit = "D"
        when 2
            cardSuit = "C"
        when 3
            cardSuit = "S"
        end
        
        print "#{cardNumber}#{cardSuit} "
    end
    
    def inPlay
        puts @@inPlay
    end
end

class Hand < Card
    include CalculatorsForOneHandAndCommunity
    include CalculatorsForTwoHands
    
    attr_reader :hand
    
    def initialize(card1=nil, card2=nil)
        @card1 = card1
        @card2 = card2
        @card1 ||= Card.new
        @card2 ||= Card.new
        @hand = [@card1, @card2]
    end
    
   
    
    def showHand()
        @hand.each do |card|
           print card.showCard()
        end
    end
    
    
end

class Community < Card
    attr_reader :community
    def initialize(*cards)
        @community = []
        @community += cards
        for i in 0...5
            @community[i] ||= Card.new
        end
            
    end
    
    def showCommunity()
        @community.each do |card|
           print card.showCard()
        end
    end
    
    def passCommunityCards
        return [] if @community == nil
        return @community
    end
end


    

=begin
myCard1 = Card.new(13,0)
print myCard1.showCard()
myCard2 = Card.new(12,1)
puts myCard2.showCard()
commCard1 = Card.new(11,0)
print commCard1.showCard()
commCard2 = Card.new(10,1)
print commCard2.showCard()
commCard3 = Card.new(3,1)
print commCard3.showCard()
commCard4 = Card.new(5,2)
print commCard4.showCard()
commCard5 = Card.new(4,3)
puts commCard5.showCard()


myhand = Hand.new(myCard1, myCard2)
myhand.showHand()
puts " "
firstCommunity = Community.new(commCard1, commCard2, commCard3, commCard4, commCard5)
firstCommunity.showCommunity()
puts " "
myhand.detectMadeHand(firstCommunity)
=end

include StatiticalCalculators



myhand = Hand.new()
myhand.showHand()
puts " "
firstCommunity = Community.new()
firstCommunity.showCommunity()
puts " "
print myhand.detectMadeHand(firstCommunity).to_s
myhand.detectMadeHand(firstCommunity)
puts "------"
yourhand = Hand.new()
yourhand.showHand()
puts " "
yourhand.detectMadeHand(firstCommunity)
print yourhand.detectMadeHand(firstCommunity).to_s
puts " "
myhand.compareTwoHands(firstCommunity, myhand, yourhand)
inPlay = firstCommunity.community + myhand.hand

arrayOfBetterHands = generateAllHandsThatBeatMine(firstCommunity, myhand, inPlay)
arrayOfBetterHands.each do |hand|
    hand.showHand()
    print ", "
end
puts "your winning percentage is: " + winningHeadsUpPercentageAfterRiver(firstCommunity, myhand).to_s + " %"

=begin bit of code to genereate deck
52.times do
    card = Card.new
    print card.showCard() + " "
end
=end