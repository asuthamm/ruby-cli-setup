# Restaurant.destroy_all
# Customer.destroy_all
# Review.destroy_all

# restaurants = ["Cecconi’s Dumbo", "Atrium Dumbo", "AlMar", "Juliana’s Pizza", "Westville Dumbo", "The Osprey", "DUMBO", "Celestine", "Superfine", "Taco Dumbo"] 

# zip = ["11201", "11011", "11201", "11201"]

# rt = ["San Vito", "Laico's", "Mona Lisa"]
rt = ["Liu’s Shanghai", "Sungai Malaysian Cuisine", "Little Saigon Pearl"]
rt.each do |rt|
    Restaurant.create(name: rt, city: "Bayonne", state: "NJ", zip_code: "11214")
end 

# restaurants.each do |restaurant|
#     Restaurant.create(name: restaurant, city: "Brooklyn", state: "NY", zip_code: zip.sample)
# end

# -------------------------------------------

fname = ["Alex", "Dana", "Ashley", "Carl", "Rey", "Sam", "Alvin", "Pam", "Jordan", "Vinnie", "Joana", "Kory", "Alberto", "Zada", "Kia", "Cecila", "Julene,", "Tal", "Nicola", "Denise", "Lindsay", "Alysia", "Arnold"]
lname = ["Lee", "Cola", "Uresti", "Rutt", "Picone", "Dobbin", "Clampitt", "Timmer", "Markowski", "Aleman", "Dickert", "Truby", "Farris", "Halley", "Virgil", "Ducan", "Petti", "Shelman", "Kao", "Schuh", "Delamora", "Behar"]
zip = ["07302", "11201", "11201", "11011", "11201"]

# 15.times do 
#     Customer.create(first_name: fname.sample, last_name: lname.sample, zip_code: zip.sample)
# end

# create_table :customers do |t|
#     t.string :first_name
#     t.string :last_name
#     t.string :zip_code
#   end

# -------------------------------------------
reviews = ["I like this place.", "Nice settings but food is so-so",
"Only problem is taking too long for my food.", "My regular weekly visit.", "took my visitors there over the weekend.", "This is is lively!", "You must try their daily house special!", "just Wow!", "Crowded on Saturday night."]


40.times do 
    Review.create(rating: rand(1..5), comment: reviews.sample, customer_id: rand(47..61), restaurant_id: rand(21..30))
end



    # create_table :reviews do |t|
    #     t.integer :rating
    #     t.string  :review
    #     t.integer :customer_id*
    #     t.integer :restaurant_id*
    #   end