require "test_helper"

class PlacesPageTest < ActionDispatch::IntegrationTest
  test "The place's page lists each of its entries with its title and the day it happened." do
    lisbon = Place.new
    lisbon["name"] = "Lisbon"
    lisbon.save
    kyoto = Place.new
    kyoto["name"] = "Kyoto"
    kyoto.save

    tram = Entry.new
    tram["title"] = "Tram 28 at sunrise"
    tram["occurred_on"] = "2026-03-14"
    tram["place_id"] = lisbon["id"]
    tram.save
    sardines = Entry.new
    sardines["title"] = "Grilled sardines in Alfama"
    sardines["occurred_on"] = "2026-03-15"
    sardines["place_id"] = lisbon["id"]
    sardines.save
    inari = Entry.new
    inari["title"] = "Fushimi Inari before breakfast"
    inari["occurred_on"] = "2025-11-02"
    inari["place_id"] = kyoto["id"]
    inari.save

    get("/places/#{lisbon["id"]}")

    assert_response(:success)
    assert_select("li", 2)
    assert_select("li", "Tram 28 at sunrise, 2026-03-14")
    assert_select("li", "Grilled sardines in Alfama, 2026-03-15")
    assert_not_includes(response.body, "Fushimi Inari before breakfast")
  end
end
