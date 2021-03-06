require 'card'

describe Card do

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  before(:each) do
    @card = Card.new(10)
  end

  it 'Card has intialised amount' do
    expect(@card.balance).to eq 10
  end

  it 'Card has a default amount' do
    expect(subject.balance).to eq 0
  end

  it 'add money to card' do
    subject.top_up(10)
    expect(subject.balance).to eq 10
  end

  it 'raises error if top up will go over card limit' do
    expect { subject.top_up(91) }.to raise_error "Top up would take balance over card limit - £#{Card::LIMIT}"
  end

  it 'starts a journey' do
    @card.touch_in("camden")
    expect(@card.ongoing_journey?).to eq true
  end

  it 'ends a journey' do
    @card.touch_in(entry_station)
    @card.touch_out(exit_station)
    expect(@card.ongoing_journey?).to eq false
  end

  it 'Doesnt allow you through the barrier if balance less than £1' do
    card = Card.new(0.99)
    expect { card.touch_in(entry_station) }.to raise_error "You need a minimum balance of £#{Card::MINIMUM_FARE} to enter barrier."
  end

  it 'deducts the journey cost from balance' do
    @card.touch_in(entry_station)
    expect {@card.touch_out(exit_station)}.to change{@card.balance}.by(-(Card::MINIMUM_FARE))
  end

  it 'returns an empty list for a new card' do
    expect(subject.journey_list.length).to eq 0
  end

  it 'returns a list of journeys saved on the card' do
    @card.touch_in(entry_station)
    @card.touch_out(exit_station)
    expect(@card.journey_list.length).to eq 1
  end


  it 'returns a list of journeys (along with the zones) saved on the card' do
    @card.touch_in("Camden")
    @card.touch_out("Clapham")
    expect(@card.journey_list.last[:startzone]).to eq 1
    expect(@card.journey_list.last[:destinationzone]).to eq 1
  end

end
