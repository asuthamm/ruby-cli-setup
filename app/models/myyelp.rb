class MyYelp
attr_reader

require "tty-prompt"
prompt = TTY::Prompt.new

    def run
        welcome
        # logo
    end

    private

    def welcome                           #--------------------
        system "clear"
        prompt = TTY::Prompt.new
        puts "- - -  Welcome to myYelp  - - - "
        puts ""
        puts "Please enter your user_id or '?' to search for your account"
        puts "or just hit enter to create new account"

        opt = gets.chomp
        case opt
        when ""
            new_user
        when "?"
            search_user
        else
            @search_id = opt
            return_user
        end

    end

    def new_user                    # ---------------
        system "clear"
        puts 'What is your first name?'
        fname = gets.chomp

        puts 'What is your last name?'
        lname = gets.chomp

        puts "What is your zip code?"
        zip = gets.chomp
        
        accept_policy_and_term
        system "clear"
        logo
        puts "Welcome, #{fname} #{lname} from zip code #{zip}"
        Customer.create(first_name: fname,last_name: lname, zip_code: zip)       #<======
        puts "You are customer#: #{Customer.all.last.id}"
        @user = Customer.find(Customer.all.last.id)
        puts "..."
        opt = gets.chomp
        task_list
    end

    def return_user              # ----------------
        system "clear"
        @user = Customer.find(@search_id)
        task_list
    end

    def search_user                 # -------------------
        system "clear"
        puts 'What is your first name?'
        fname = gets.chomp

        puts 'What is your last name?'
        lname = gets.chomp
        # binding.pry
        @user = Customer.all.find { |cust| cust.first_name == fname && cust.last_name == lname } 
        if !!@user == false
            not_found
            welcome
        end
        puts "User found# #{@user.id}"
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "..."
        opt = gets.chomp
        task_list
    end

    def task_list
        system "clear"
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "User# #{@user.id}"
        puts ""
        puts "1.  All the restaurants in my zip code profile"
        puts "2.  All the reviews I posted"
        puts "3.  Create new review"
        puts "4.  Update my previous review"
        puts "5.  Delete my previous review"
        puts "6.  Change my location"
        puts "9.  Exit"
        puts ""
        puts "Please enter your option below:"
        opt = gets.chomp
        # binding.pry
        case opt
        when "1"                      # list by zip
            list_restaurants
            task_list
        when "2"                      # list my restaurants
            my_reviews
            task_list
        when "3"                      # create new review
            create_review
            task_list
        when "4"                      # chg my review
            chg_rating
            view_my_review
            task_list
        when "5"                      # delete my review       
            review_delete
            task_list
        when "6"                      # delete my review       
            new_location
            task_list
        when "9"                      # bye
            p 'Bye for now.'
            app_exit
        when "c"                      # console
            binding.pry
            task_list
        else
            task_list
        end
        
    end

    def list_restaurants                    # option 1
        system "clear"
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "User# #{@user.id}"
        puts ""
        puts "======================================================"
        puts "==             Restaurant in my area:               ==" 
        puts "==             Rating    <--     Name               =="
        puts "======================================================"

        all_restaurants = Restaurant.all.reload.select  { |rest| rest.zip_code == @user.zip_code }
        # all_restaurants = Restaurant.all.select  { |rest| rest.zip_code == @user.zip_code }

        # sorted  = all_restaurants.sort_by { |restaurant| -restaurant.avg_rating }
        sorted  = all_restaurants.sort_by { |restaurant| restaurant.name }
        sorted.each  { |rt| puts "                #{rt.avg_rating}       -      #{rt.name}" }
        puts "..."
        opt = gets.chomp
    end

    def my_reviews                       # option 2
        # binding.pry
        system "clear"
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "User# #{@user.id}"
        puts ""
        puts "Here are the list of my restaurants I had visited in the past:"
        puts "======================================================"
        puts "==          All of my restaurant reviews            ==" 
        puts "==             Rating    <--     Name               =="
        puts "======================================================"
        # @user.reviews.reload.each do |review|
        @user.reviews.each do |review|
            puts "                 #{review.rating}        -      #{review.restaurant.id}-#{review.restaurant.name}"
         end 

        puts "..."
        opt = gets.chomp
    end

    def create_review                  # option 3
        system "clear"
        prompt = TTY::Prompt.new
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "User# #{@user.id}"
        puts ""

        restaurant_arr = Restaurant.all.map { |rt| rt.name }
        sch_rest = prompt.select("Choose your restaurant?", restaurant_arr)

        t_rating = prompt.ask('Please enter the rating (1-5):  ')
        if (1..5).include?(t_rating.to_i) == false
            invalid_input
            task_list
        end
        t_comnt  = prompt.ask('Please enter the comment     :  ')

        rt_id = Restaurant.all.find { |rt| rt.name == sch_rest}.id
        Review.create(rating: t_rating, comment: t_comnt, customer_id: @user.id, restaurant_id: rt_id)
        # view_my_review
    end

    def search_review           # ref by (4)chg_rating & review_delete
        system "clear"
        prompt = TTY::Prompt.new
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "User# #{@user.id}"
        puts ""
        # binding.pry
        restaurant_arr = @user.restaurants.reload.map { |rt| rt.name }

        if restaurant_arr.empty?
            not_found
            task_list
        end

        sch_rest = prompt.select("Choose your restaurant?", restaurant_arr)

        @my_review = @user.reviews.reload.find { |review| review.restaurant.name == sch_rest}

        puts "Your current review for #{@my_review.restaurant.name}"
        puts "================================================================================="
        puts "#{@my_review.rating}    -     #{@my_review.comment}"
        puts "================================================================================="
        puts ""
    end

    def chg_rating                        # option 4
        search_review
        prompt = TTY::Prompt.new
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "User# #{@user.id}"
        puts ""

        new_rating = prompt.ask('Please enter the new rating (1-5):  ')
        if (1..5).include?(new_rating.to_i) == false
            invalid_input
            task_list
        end
        new_comnt  = prompt.ask('Please enter the new comment     :  ')

        @my_review.update(rating: new_rating, comment: new_comnt)

    end

    def view_my_review                  # option 4b
        system "clear"
        puts "Welcome back, #{@user.first_name} #{@user.last_name} from zip code #{@user.zip_code}"
        puts "User# #{@user.id}"
        puts ""
        puts "Your reviews for #{@my_review.restaurant.name}"
        # p "Your reviews for #{@my_review.restaurant.name}"
        puts "===================================================="
        puts "#{@my_review.rating}    -     #{@my_review.comment}"
        opt = gets.chomp
    end
    
    def review_delete
        search_review
        puts ""
        puts ""
        puts "==================================================="
        puts "==  Caution! You're about to delete your review  =="
        puts "==================================================="
        opt = gets.chomp.downcase
        # binding.pry
        case opt 
        when "delete"
            # binding.pry
            @my_review.destroy
        else
            invalid_input
        end
        # opt = gets.chomp
    end

    def new_location
        system "clear"
        prompt = TTY::Prompt.new
        new_loc = prompt.ask('What is your new zip code?')
        @user.zip_code = new_loc
    end

    def not_found
        system "clear"
        puts "=================================================="
        puts "========      Sorry! No record found      ========"
        puts "=================================================="
        puts "..."
        opt = gets.chomp
    end

    def invalid_input
        system "clear"
        puts "=================================================="
        puts "========      Abort! Invalid input(s)     ========"
        puts "=================================================="
        puts "..."
        opt = gets.chomp
    end

    def accept_policy_and_term
        system "clear"
        prompt = TTY::Prompt.new
        File.open("terms.txt").each { |line| puts line }
        puts ""
        ans = prompt.yes?('Do you accept myYelp Terms of Service?')

        if ans != true
            app_exit
        end

        File.open("privacy.txt").each { |line| puts line }
        puts ""
        ans = prompt.yes?('Do you accept myYelp Privacy Policy?')
        if ans != true
            app_exit
        end

    end

    def logo
        puts "                      Y88b   d88P       888             "         
        puts "                       Y88b d88P        888             "
        puts "                        Y88o88P         888             "
        puts "  88888b.d88b.  888  888 Y888P  .d88b.  888 88888b.     "
        puts "  888 '888 '88b 888  888  888  d8P  Y8b 888 888 '88b    "
        puts "  888  888  888 888  888  888  88888888 888 888  888    "
        puts "  888  888  888 Y88b 888  888  Y8b.     888 888 d88P    "
        puts "  888  888  888  'Y88888  888   'Y8888  888 88888P'     "
        puts "                     888                    888         "
        puts "                Y8b d88P                    888         "
        puts "                 'Y88P'                     888         "
        puts ""
    end
    def app_exit
        system "clear"
        abort("Exiting the myYelp....")
    end
end

