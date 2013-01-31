require 'httparty'

class LeaderFinder
  include HTTParty
  base_uri 'api.publicservantsprayer.org'
  #base_uri 'localhost:8081'

  def self.find(slug)
    result = get("/v1/leaders/#{slug}")
    leader = Leader.new
    leader.setup(result)
    leader
  end

  def self.by_state(state_code)
    get_leaders "/v1/states/#{state_code}/leaders"
  end

  def self.us_senate(state_code)
    get_leaders "/v1/states/#{state_code}/leaders/us_senate"  
  end

  def self.us_house(state_code)
    get_leaders "/v1/states/#{state_code}/leaders/us_house"  
  end

  def self.state_senate(state_code)
    get_leaders "/v1/states/#{state_code}/leaders/state_senate"  
  end

  def self.state_house(state_code)
    get_leaders "/v1/states/#{state_code}/leaders/state_house"  
  end

  def self.us_congress(state_code)
    us_senate(state_code) + us_house(state_code)
  end

  private

    def self.get_leaders(endpoint)
      results = cached_get(endpoint)
      begin
        leaders(results)
      rescue
        expire_cache(endpoint)
        leaders(results)
      end
    end

    def self.leaders(results)
      leaders = []
      results.each do |data|
        leader = Leader.new
        leader.setup(data)
        leaders << Leader.new(leader)
      end
      leaders
    end

    def self.cached_get(endpoint)
      Rails.cache.fetch(endpoint) do
        get(endpoint).parsed_response
      end
    end

    def self.expire_cache(endpoint)
      Rails.cache.delete(endpoint)
    end

end
