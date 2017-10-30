require 'spec_helper'
require './lib/pace'

RESPONSE_DATA = File.read('./spec/fixtures/stats_page.html')

context 'parse pace output' do
  it 'Should return an array of data' do
    stub_request(:get, "http://gateway.sonic.net/xslt?PAGE=C_1_0").
         with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent'=>'Ruby'}).
         to_return(status: 200, body: RESPONSE_DATA, headers: {})

    response = Pace.new.gather

    expect(response).to be_an_instance_of(Array)
  end
end
