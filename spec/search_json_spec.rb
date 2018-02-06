require 'rspec'
require 'zensearch'

describe 'validations test' do
  before do
    @search_json = SearchJson.new('spec/fixtures/search_test.json')
  end

  it 'should validate if the field is present in the file' do
    expect(@search_json.validate_field(['fieldA'])).to eq(true)
  end

  it 'should validate if multiple fields are present in the file' do
    expect(@search_json.validate_field(%w[fieldA fieldB])).to eq(true)
  end

  it 'should not validate if the field is not present in the file' do
    expect(@search_json.validate_field(['fieldZ'])).to eq(false)
  end

  it 'should not validate if one of the fields are absent in the file' do
    expect(@search_json.validate_field(%w[fieldA fieldZ])).to eq(false)
  end

  it 'should return unique fields from a collection' do
    uniq_list = %w[fieldA fieldB fieldC fieldD fieldE fieldF fieldG fieldH]
    expect(@search_json.uniq_fields).to match_array(uniq_list)
  end
end

describe 'search test' do
  before do
    @right_matches = [{   'fieldA' => 6,
                          'fieldB' => 'Scooby Doo',
                          'fieldC' => %w[Shaggy Fred Velma] }]
    @right_matches2 = [{  'fieldB' => 'Demagorgon',
                          'fieldF' => 'Grrrrrrrrr' }]
  end

  it 'should search for a given key that has string value' do
    search_json = SearchJson.new(
      'spec/fixtures/search_test.json',
      ['fieldB'], ['Scooby Doo']
    )
    search_json.filter_obj_list
    expect(search_json.obj_list).to eq(@right_matches)
  end

  it 'should search for a given field key that has integer value' do
    search_json = SearchJson.new(
      'spec/fixtures/search_test.json',
      ['fieldA'], ['6']
    )
    search_json.filter_obj_list
    expect(search_json.obj_list).to eq(@right_matches)
  end

  it 'should search for a given field key that has array value' do
    search_json = SearchJson.new(
      'spec/fixtures/search_test.json',
      ['fieldC'], ['Fred']
    )
    search_json.filter_obj_list
    expect(search_json.obj_list).to eq(@right_matches)
  end

  it 'should search for a given field key that has no value' do
    search_json = SearchJson.new(
      'spec/fixtures/search_test.json',
      ['fieldA'], [nil]
    )
    search_json.filter_obj_list
    expect(search_json.obj_list).to eq(@right_matches2)
  end

  it 'should return a message if there is no match' do
    search_json = SearchJson.new(
      'spec/fixtures/search_test.json',
      ['fieldC'], ['Scrappy']
    )
    search_json.filter_obj_list
    expect(search_json.obj_list).to eq([['Cannot find field(s) fieldC '\
      'with value(s) Scrappy in search_test']])
  end
end

describe 'search test with multiple paramters' do
  before do
    @right_matches = [{ 'fieldA' => 2,
                        'fieldB' => '1985',
                        'fieldD' => 'McFly',
                        'fieldE' => false,
                        'fieldF' => 'Nobody calls me chicken!' },
                      { 'fieldA' => 10,
                        'fieldB' => '1985',
                        'fieldD' => '2015',
                        'fieldE' => false,
                        'fieldF' => 'Great Scott!' }]
  end

  it 'should search for the combination of given keys with values' do
    search_json = SearchJson.new(
      'spec/fixtures/search_test.json',
      %w[fieldB fieldE], %w[1985 false]
    )
    search_json.filter_obj_list
    expect(search_json.obj_list).to eq(@right_matches)
  end

  it 'should return a message if there is no match' do
    search_json = SearchJson.new(
      'spec/fixtures/search_test.json',
      %w[fieldE fieldF], %w[false true]
    )
    search_json.filter_obj_list
    expect(search_json.obj_list).to eq([['Cannot find field(s) '\
      'fieldE,fieldF with value(s) false,true in search_test']])
  end
end


describe 'format test' do
  it 'should format arrays as rows for output' do
    given = [1, '2', [3, 4]]
    right_format = [[1], ['2'], [[3, 4]]]
    expect(PrintTable.format_as_rows(given)).to match_array(right_format)
  end

  it 'should format hashes as rows for output' do
    given = { a: 1, b: [1, 2], c: 'd' }
    right_format = [[:a, 1], [:b, [1, 2]], [:c, 'd']]
    expect(PrintTable.format_as_rows(given)).to match_array(right_format)
  end
end
