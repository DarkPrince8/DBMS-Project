CREATE DATABASE real_estate;
USE real_estate;

CREATE TABLE Person(
	person_id INT PRIMARY KEY AUTO_INCREMENT,
	person_name VARCHAR(100),
    person_email VARCHAR(100) NOT NULL
);

CREATE TABLE Person_contact(
	phone_number VARCHAR(10),
    CHECK (phone_number REGEXP '^[0-9]{10}$'),
    person_id INT,
    PRIMARY KEY(phone_number, person_id),
    FOREIGN KEY(person_id) REFERENCES Person(person_id)
);

CREATE TABLE Agent(
	agent_id INT PRIMARY KEY AUTO_INCREMENT,
    agent_name VARCHAR(100),
    join_date DATE,
    agent_email VARCHAR(100) NOT NULL
    #commission DECIMAL(5,2)
);

CREATE TABLE Agent_contact(
	phone_number VARCHAR(10),
    CHECK (phone_number REGEXP '^[0-9]{10}$'),
    agent_id INT,
    PRIMARY KEY(phone_number,agent_id),
    FOREIGN KEY(agent_id) REFERENCES Agent(agent_id)
);

CREATE TABLE Property(
    property_id INT PRIMARY KEY AUTO_INCREMENT,
    year_build INT NOT NULL,
    sqft INT NOT NULL,
    bathrooms INT NOT NULL,
    bedrooms INT NOT NULL,
    property_type VARCHAR(50) NOT NULL,
    address VARCHAR(200) NOT NULL,
    block_address VARCHAR(100),
    street VARCHAR(100) NOT NULL
);

CREATE TABLE Property_image(
	image_id INT PRIMARY KEY AUTO_INCREMENT,
    image_url VARCHAR(500),
    property_id INT NOT NULL,
    FOREIGN KEY(property_id) REFERENCES Property(property_id)
);

CREATE TABLE Sale_listing(
    sale_listing_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    listing_date DATE,
    listing_price DECIMAL(10,2),
    agent_id INT NOT NULL,
    FOREIGN KEY(property_id) REFERENCES Property(property_id),
    FOREIGN KEY(agent_id) REFERENCES Agent(agent_id)
);

CREATE TABLE Sold(
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_price DECIMAL(10,2) NOT NULL,
    sale_listing_id INT NOT NULL,
    sale_date DATE NOT NULL,
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL,
    agent_id INT NOT NULL,
    FOREIGN KEY(sale_listing_id) REFERENCES Sale_listing(sale_listing_id),
    FOREIGN KEY(buyer_id) REFERENCES Person(person_id),
    FOREIGN KEY(agent_id) REFERENCES Agent(agent_id),
    FOREIGN KEY(seller_id) REFERENCES Person(person_id)
);

CREATE TABLE Rent_listing(
	rent_listing_id INT PRIMARY KEY AUTO_INCREMENT,
    property_id INT,
    listing_date DATE,
    listing_price DECIMAL(10,2),
    agent_id INT NOT NULL,
    FOREIGN KEY(property_id) REFERENCES Property(property_id),
    FOREIGN KEY(agent_id) REFERENCES Agent(agent_id)
);

CREATE TABLE Rented(
    rent_id INT PRIMARY KEY AUTO_INCREMENT,
    rent_price DECIMAL(10,2),
    rent_listing_id INT,
    rent_date DATE,
    tenant_id INT NOT NULL,
    owner_id INT NOT NULL,
    agent_id INT NOT NULL,
    FOREIGN KEY(rent_listing_id) REFERENCES Rent_listing(rent_listing_id),
    FOREIGN KEY(tenant_id) REFERENCES Person(person_id),
    FOREIGN KEY(agent_id) REFERENCES Agent(agent_id),
    FOREIGN KEY(owner_id) REFERENCES Person(person_id)
);


#no more than 2 phone numbers else new row is null value
DELIMITER //
CREATE TRIGGER limit_person_phone
BEFORE INSERT ON Person_contact
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) 
        FROM Person_contact 
        WHERE person_id = NEW.person_id) >= 2 THEN
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Max 2 phone numbers allowed per person';
        
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER seller_and_buyer_cannot_be_same_in_sold
BEFORE INSERT ON Sold
FOR EACH ROW
BEGIN
    IF NEW.seller_id = NEW.buyer_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Buyer and seller cannot be same';
    END IF;
END //
DELIMITER ;



DELIMITER //
CREATE TRIGGER seller_and_buyer_cannot_be_same_in_rented
BEFORE INSERT ON Rented
FOR EACH ROW
BEGIN
    IF NEW.tenant_id = NEW.owner_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tenant and owner cannot be same';
    END IF;
END //
DELIMITER ;




INSERT INTO Person (person_name, person_email) VALUES
('Arjun Sharma', 'arjun.sharma@gmail.com'),
('Priya Nair', 'priya.nair@yahoo.com'),
('Rahul Mehta', 'rahul.mehta@hotmail.com'),
('Sneha Reddy', 'sneha.reddy@gmail.com'),
('Vikram Singh', 'vikram.singh@outlook.com'),
('Ananya Iyer', 'ananya.iyer@gmail.com'),
('James Carter', 'james.carter@gmail.com'),
('Emily Watson', 'emily.watson@yahoo.com'),
('Michael Zhang', 'michael.zhang@gmail.com'),
('Sofia Alvarez', 'sofia.alvarez@hotmail.com'),
('Ravi Patel', 'ravi.patel@gmail.com'),
('Fatima Sheikh', 'fatima.sheikh@outlook.com'),
('Karan Malhotra', 'karan.malhotra@gmail.com'),
('Divya Kapoor', 'divya.kapoor@yahoo.com'),
('Suresh Babu', 'suresh.babu@gmail.com'),
('Meera Joshi', 'meera.joshi@outlook.com'),
('Aditya Bose', 'aditya.bose@gmail.com'),
('Pooja Chaudhary', 'pooja.chaudhary@hotmail.com'),
('Nikhil Rao', 'nikhil.rao@gmail.com'),
('Tanvi Desai', 'tanvi.desai@yahoo.com'),
('Harish Nambiar', 'harish.nambiar@gmail.com'),
('Sakshi Pandey', 'sakshi.pandey@outlook.com'),
('Oliver Bennett', 'oliver.bennett@gmail.com'),
('Isabella Rossi', 'isabella.rossi@gmail.com'),
('Lucas Muller', 'lucas.muller@web.de'),
('Chloe Dupont', 'chloe.dupont@gmail.com'),
('Ethan Williams', 'ethan.williams@yahoo.com'),
('Yuki Tanaka', 'yuki.tanaka@gmail.com'),
('Ahmed Al-Rashid', 'ahmed.alrashid@gmail.com'),
('Nina Petrov', 'nina.petrov@mail.ru');

INSERT INTO Person_contact (phone_number, person_id) VALUES
('9876543210', 1),
('9123456780', 2),
('9988776655', 3),
('9871234560', 4),
('9765432109', 5),
('9654321098', 6),
('9543210987', 7),
('9432109876', 8),
('9321098765', 9),
('9210987654', 10),
('9109876543', 11),
('9098765432', 12),
('9001122334', 13),
('9002233445', 14),
('9003344556', 15),
('9004455667', 16),
('9005566778', 17),
('9006677889', 18),
('9007788990', 19),
('9008899001', 20),
('9009900112', 21),
('9010011223', 22),
('9011122334', 23),
('9012233445', 24),
('9013344556', 25),
('9014455667', 26),
('9015566778', 27),
('9016677889', 28),
('9017788990', 29),
('9018899001', 30);

INSERT INTO Agent (agent_name, join_date, agent_email) VALUES
('Deepak Verma', '2019-03-15', 'deepak.verma@realestate.com'),
('Kavya Krishnan', '2020-07-01', 'kavya.krishnan@realestate.com'),
('Robert Hughes', '2018-11-20', 'robert.hughes@realestate.com'),
('Lena Fischer', '2021-02-10', 'lena.fischer@realestate.com'),
('Manish Gupta', '2017-06-25', 'manish.gupta@realestate.com'),
('Sunita Agarwal', '2022-01-15', 'sunita.agarwal@realestate.com'),
('Prakash Menon', '2019-09-10', 'prakash.menon@realestate.com'),
('Chris Thompson', '2020-04-22', 'chris.thompson@realestate.com'),
('Aisha Qureshi', '2021-08-30', 'aisha.qureshi@realestate.com'),
('Marco Conti', '2018-03-05', 'marco.conti@realestate.com');

INSERT INTO Agent_contact (phone_number, agent_id) VALUES
('8800112233', 1),
('8811223344', 2),
('8822334455', 3),
('8833445566', 4),
('8844556677', 5),
('8855667788', 6),
('8866778899', 7),
('8877889900', 8),
('8888990011', 9),
('8899001122', 10);

INSERT INTO Property (year_build, sqft, bathrooms, bedrooms, property_type, address, block_address, street) VALUES
(2010, 1200, 2, 3, 'Apartment', '12, Green Valley Apartments, MG Road', 'Block A', 'MG Road'),
(2005, 2400, 3, 4, 'Villa', '45, Sunrise Villa, Jubilee Hills', 'Block B', 'Jubilee Hills Road'),
(2018, 850, 1, 2, 'Apartment', '7, Skyline Heights, Koramangala', 'Block C', '5th Cross Road'),
(2000, 3200, 4, 5, 'Independent', '88, Palm Grove, Banjara Hills', NULL, 'Road No. 12'),
(2015, 1500, 2, 3, 'Apartment', '23, Sea Breeze Towers, Marine Drive', 'Block D', 'Marine Drive'),
(2012, 950, 1, 2, 'Studio', '5, Urban Nest, Connaught Place', NULL, 'Inner Circle'),
(2020, 1800, 3, 4, 'Apartment', '101, Prestige Towers, Whitefield', 'Block E', 'ITPL Main Road'),
(2008, 2800, 3, 5, 'Villa', '34, Royal Enclave, Golf Course Road', 'Block F', 'Golf Course Ext Road'),
(2017, 1100, 2, 3, 'Apartment', '9, Maple Residency, HSR Layout', 'Block G', '27th Main Road'),
(2003, 4000, 5, 6, 'Independent', '2, Heritage Bungalow, Civil Lines', NULL, 'Civil Lines Road'),
(2016, 1350, 2, 3, 'Apartment', '14, Lotus Tower, Andheri West', 'Block A', 'Link Road'),
(2011, 2600, 3, 4, 'Villa', '22, Green Meadows, Sarjapur Road', NULL, 'Sarjapur Main Road'),
(2019, 780, 1, 1, 'Studio', '3, Compact Living, Indiranagar', 'Block B', '100 Feet Road'),
(2007, 3500, 4, 5, 'Independent', '67, Lakeview Bungalow, Powai', NULL, 'Hiranandani Gardens'),
(2021, 1650, 2, 3, 'Apartment', '55, Horizon Heights, Gachibowli', 'Block C', 'Financial District Road'),
(2014, 1050, 2, 2, 'Apartment', '8, Silver Oak, Kalyani Nagar', 'Block D', 'Nagar Road'),
(2009, 2200, 3, 4, 'Villa', '31, Palm Court, Hebbal', NULL, 'Outer Ring Road'),
(2022, 900, 1, 2, 'Apartment', '19, Neo Living, Electronic City', 'Block E', 'Hosur Road'),
(2004, 4500, 5, 7, 'Independent', '1, Governor Estate, Lutyens Zone', NULL, 'Prithviraj Road'),
(2018, 1400, 2, 3, 'Apartment', '40, Emerald Isle, Vashi', 'Block F', 'Sector 30 Road'),
(2013, 1700, 2, 3, 'Apartment', '77, Blue Ridge, Hinjewadi', 'Block G', 'Phase 1 Road'),
(2006, 3000, 4, 5, 'Villa', '5, Royal Palms, Goregaon East', NULL, 'Film City Road'),
(2020, 1200, 2, 3, 'Apartment', '62, The Residency, Manikonda', 'Block H', 'Puppalaguda Road'),
(2015, 820, 1, 2, 'Studio', '11, Urban Studio, Koramangala', 'Block I', '80 Feet Road'),
(2001, 5000, 6, 8, 'Independent', '3, Imperial Manor, Race Course Road', NULL, 'Race Course Road'),
(2017, 1550, 2, 3, 'Apartment', '28, Serene Heights, Khar West', 'Block J', 'SV Road'),
(2023, 2000, 3, 4, 'Apartment', '88, Zenith Towers, Kondapur', 'Block K', 'Kondapur Main Road'),
(2010, 2700, 3, 5, 'Villa', '14, Willow Creek, Langford Town', NULL, 'Hosur Main Road'),
(2016, 1300, 2, 3, 'Apartment', '33, Skyview, Sector 62, Noida', 'Block L', 'Expressway'),
(2019, 950, 1, 2, 'Apartment', '6, Compact Nest, Wakad', 'Block M', 'Wakad Road');


INSERT INTO Property_image (image_url, property_id) VALUES
('https://images.realestate.com/prop1_front.jpg', 1),
('https://images.realestate.com/prop1_hall.jpg', 1),
('https://images.realestate.com/prop2_front.jpg', 2),
('https://images.realestate.com/prop2_pool.jpg', 2),
('https://images.realestate.com/prop3_front.jpg', 3),
('https://images.realestate.com/prop4_aerial.jpg', 4),
('https://images.realestate.com/prop5_sea.jpg', 5),
('https://images.realestate.com/prop6_studio.jpg', 6),
('https://images.realestate.com/prop7_tower.jpg', 7),
('https://images.realestate.com/prop8_villa.jpg', 8),
('https://images.realestate.com/prop9_front.jpg', 9),
('https://images.realestate.com/prop10_aerial.jpg', 10),
('https://images.realestate.com/prop11_front.jpg', 11),
('https://images.realestate.com/prop12_garden.jpg', 12),
('https://images.realestate.com/prop13_studio.jpg', 13),
('https://images.realestate.com/prop14_lake.jpg', 14),
('https://images.realestate.com/prop15_front.jpg', 15),
('https://images.realestate.com/prop16_hall.jpg', 16),
('https://images.realestate.com/prop17_villa.jpg', 17),
('https://images.realestate.com/prop18_front.jpg', 18),
('https://images.realestate.com/prop19_aerial.jpg', 19),
('https://images.realestate.com/prop20_sea.jpg', 20),
('https://images.realestate.com/prop21_front.jpg', 21),
('https://images.realestate.com/prop21_balcony.jpg', 21),
('https://images.realestate.com/prop22_pool.jpg', 22),
('https://images.realestate.com/prop23_studio.jpg', 23),
('https://images.realestate.com/prop24_front.jpg', 24),
('https://images.realestate.com/prop25_lobby.jpg', 25),
('https://images.realestate.com/prop26_front.jpg', 26),
('https://images.realestate.com/prop27_tower.jpg', 27),
('https://images.realestate.com/prop28_villa.jpg', 28),
('https://images.realestate.com/prop29_front.jpg', 29),
('https://images.realestate.com/prop30_balcony.jpg', 30);



INSERT INTO Sale_listing (property_id, listing_date, listing_price, agent_id) VALUES
(1, '2024-01-10', 7500000.00, 1),
(2, '2024-02-15', 18000000.00, 3),
(4, '2023-11-01', 32000000.00, 5),
(7, '2024-03-05', 12500000.00, 2),
(8, '2024-01-20', 25000000.00, 4),
(11, '2024-01-18', 9500000.00, 6),
(12, '2024-02-10', 21000000.00, 7),
(14, '2023-12-05', 38000000.00, 8),
(15, '2024-03-12', 14000000.00, 9),
(17, '2024-01-25', 19500000.00, 10),
(19, '2023-11-15', 45000000.00, 1),
(21, '2024-02-28', 8800000.00, 2),
(22, '2024-03-01', 27000000.00, 3),
(24, '2023-10-20', 16000000.00, 4),
(25, '2024-04-01', 52000000.00, 5),
(27, '2024-02-05', 11200000.00, 6),
(28, '2023-09-30', 23500000.00, 7);

INSERT INTO Sold (sale_price, sale_listing_id, sale_date, buyer_id, seller_id, agent_id) VALUES
(7200000.00, 1, '2024-03-01', 7, 1, 1),
(30500000.00, 3, '2024-02-20', 9, 5, 5),
(9200000.00, 6, '2024-03-10', 13, 11, 6),
(20000000.00, 7, '2024-04-01', 24, 17, 7),
(36500000.00, 8, '2024-02-15', 25, 15, 8),
(13500000.00, 9, '2024-04-05', 27, 19, 9),
(19000000.00, 10, '2024-03-20', 29, 21, 10),
(50000000.00, 11, '2024-01-30', 23, 14, 1),
(8500000.00, 12, '2024-04-10', 16, 13, 2),
(26000000.00, 13, '2024-03-25', 28, 22, 3);

INSERT INTO Rent_listing (property_id, listing_date, listing_price, agent_id) VALUES
(3, '2024-01-05', 22000.00, 2),
(5, '2024-02-01', 35000.00, 1),
(6, '2023-12-15', 18000.00, 3),
(9, '2024-03-10', 28000.00, 4),
(10, '2023-10-01', 55000.00, 5),
(13, '2024-01-08', 15000.00, 6),
(16, '2024-02-12', 24000.00, 7),
(18, '2024-03-01', 20000.00, 8),
(20, '2023-12-20', 32000.00, 9),
(23, '2024-01-15', 19000.00, 10),
(26, '2024-02-20', 27000.00, 1),
(29, '2024-03-15', 22000.00, 2),
(30, '2023-11-10', 18500.00, 3);

INSERT INTO Rented (rent_price, rent_listing_id, rent_date, tenant_id, owner_id, agent_id) VALUES
(21000.00, 1, '2024-02-01', 8, 3, 2),
(17500.00, 3, '2024-01-10', 10, 6, 3),
(52000.00, 5, '2023-11-01', 12, 2, 5),
(14500.00, 6, '2024-02-10', 14, 20, 6),
(23000.00, 7, '2024-03-05', 26, 18, 7),
(19500.00, 8, '2024-04-01', 30, 16, 8),
(31000.00, 9, '2024-01-20', 15, 22, 9),
(18000.00, 10, '2024-02-25', 17, 23, 10),
(26000.00, 11, '2024-03-20', 20, 24, 1),
(21500.00, 12, '2024-04-08', 18, 25, 2),
(18000.00, 13, '2023-12-15', 19, 26, 3);

CREATE INDEX idx_property_type ON Property(property_type);
CREATE INDEX idx_property_bedrooms ON Property(bedrooms);
CREATE INDEX idx_sale_listing_agent_id ON Sale_listing(agent_id);
CREATE INDEX idx_sold_agent_id ON Sold(agent_id);
CREATE INDEX idx_sold_buyer_id ON Sold(buyer_id);
CREATE INDEX idx_sold_seller_id ON Sold(seller_id);
CREATE INDEX idx_rent_listing_agent_id ON Rent_listing(agent_id);
CREATE INDEX idx_rented_agent_id ON Rented(agent_id);
CREATE INDEX idx_rented_tenant_id ON Rented(tenant_id);
CREATE INDEX idx_rented_owner_id ON Rented(owner_id);