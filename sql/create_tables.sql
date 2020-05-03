-- ENTITIES

CREATE TABLE Users (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(100),
    username VARCHAR(100),
    password VARCHAR(100),
    role_type VARCHAR(100),
    date_joined TIMESTAMP,
    UNIQUE(username)
);

CREATE TABLE Riders (
    rider_id INTEGER REFERENCES Users(uid)
        ON DELETE CASCADE,
    rating DECIMAL,
    working BOOLEAN, --to know if he's working now or not
    is_delivering BOOLEAN,--to know if he's free or not
    base_salary DECIMAL, --in terms of per month
    rider_type BOOLEAN, --pt f or ft t
    commission INTEGER, --PT is $2, FT is $3
    PRIMARY KEY(rider_id),
    UNIQUE(rider_id)
);

CREATE TABLE Restaurants (
    rid INTEGER PRIMARY KEY,
    rname VARCHAR(100),
    min_order_price MONEY NOT NULL,
    unique(rid)
);

CREATE TABLE RestaurantStaff (
    uid INTEGER REFERENCES Users
        ON DELETE CASCADE,
    rid INTEGER REFERENCES Restaurants(rid)
        ON DELETE CASCADE
);

CREATE TABLE FDSManager (
    uid INTEGER REFERENCES Users
        ON DELETE CASCADE PRIMARY KEY
);

CREATE TABLE Customers (
    uid INTEGER REFERENCES Users
        ON DELETE CASCADE PRIMARY KEY,
    points INTEGER,
    credit_card VARCHAR(100)
);

CREATE TABLE FoodOrder (
    order_id SERIAL PRIMARY KEY NOT NULL,
    uid INTEGER REFERENCES Users NOT NULL,
    rid INTEGER REFERENCES Restaurants NOT NULL,
    have_credit_card BOOLEAN,
    order_cost DECIMAL NOT NULL,
    date_time TIMESTAMP NOT NULL,
    completion_status BOOLEAN,
    UNIQUE(order_id)
);

CREATE TABLE FoodItem (
    food_id INTEGER, 
    rid INTEGER REFERENCES Restaurants
        ON DELETE CASCADE,
    cuisine_type VARCHAR(100),
    food_name VARCHAR(100),
    quantity INTEGER,
    overall_rating DECIMAL,
    ordered_count INTEGER,
    availability_status BOOLEAN,
    PRIMARY KEY(food_id, rid),
    UNIQUE(food_id)
);

CREATE TABLE PromotionalCampaign (
    promo_id SERIAL PRIMARY KEY,
    rid INTEGER REFERENCES Restaurants 
        ON DELETE CASCADE,
    discount INTEGER,
    description VARCHAR(100),
    start_date TIMESTAMP,
    end_date TIMESTAMP
);

CREATE TABLE WeeklyWorkSchedule (
    wws_id SERIAL PRIMARY KEY NOT NULL,
    rider_id INTEGER references Riders(rider_id),
    start_hour INTEGER,
    end_hour INTEGER,
    day INTEGER,
    week INTEGER,
    month INTEGER,
    year INTEGER,
    shift INTEGER
);

--CREATE TABLE MonthlyWorkSchedule (
--    mws_id SERIAL PRIMARY KEY,
--    rider_id INTEGER REFERENCES Riders(rider_id), 
--    month INTEGER,
--    year INTEGER,
--    firstWWS INTEGER REFERENCES WeeklyWorkSchedule(wws_id),
--    secondWWS INTEGER REFERENCES WeeklyWorkSchedule(wws_id),
--    thirdWWS INTEGER REFERENCES WeeklyWorkSchedule(wws_id),
--    fourthWWS INTEGER REFERENCES WeeklyWorkSchedule(wws_id)
--);


--ENTITIES

--RELATIONSHIPS

CREATE TABLE Sells ( --rid, food_id -> price 
    rid INTEGER REFERENCES Restaurants(rid) NOT NULL, 
    food_id INTEGER REFERENCES FoodItem(food_id) NOT NULL,
    price MONEY NOT NULL,
    PRIMARY KEY(rid, food_id)
);

CREATE TABLE Orders ( --2 attributes thus BCNF
    order_id INTEGER REFERENCES FoodOrder(order_id),
    food_id INTEGER REFERENCES FoodItem(food_id),
    PRIMARY KEY(order_id,food_id)
);

CREATE TABLE Receives ( --2 attributes thus BCNF
    order_id INTEGER REFERENCES FoodOrder(order_id),
    promo_id INTEGER REFERENCES PromotionalCampaign(promo_id)
);

CREATE TABLE Delivery (
    delivery_id SERIAL NOT NULL,
    order_id INTEGER REFERENCES FoodOrder(order_id),
    rider_id INTEGER REFERENCES Riders(rider_id),
    delivery_cost DECIMAL NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    collected_time TIMESTAMP NOT NULL,
    delivery_start_time TIMESTAMP NOT NULL, --start delivering to customer
    delivery_end_time TIMESTAMP,
    time_for_one_delivery DECIMAL, --in hours
    location VARCHAR(100),
    delivery_rating INTEGER, 
    food_review varchar(100),
    ongoing BOOLEAN, --true means delivering, false means done
    PRIMARY KEY(delivery_id),
    UNIQUE(delivery_id)
);

CREATE TABLE Contain ( --2 attributes thus BCNF
    order_id INTEGER REFERENCES FoodOrder(order_id),
    food_id INTEGER REFERENCES FoodItem(food_id),
    PRIMARY KEY(order_id, food_id),
    UNIQUE(order_id, food_id)
);

--RELATIONSHIPS


