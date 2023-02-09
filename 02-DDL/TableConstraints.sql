-- Primary keys (PK)
ALTER TABLE Hostel ADD CONSTRAINT Hostel_PK PRIMARY KEY (Hostel_ID);
ALTER TABLE Room ADD CONSTRAINT Room_PK PRIMARY KEY (Room_ID);
ALTER TABLE Student ADD CONSTRAINT Student_PK PRIMARY KEY (Student_ID);
ALTER TABLE Technique ADD CONSTRAINT Technique_PK PRIMARY KEY (Technique_ID);
ALTER TABLE Furniture ADD CONSTRAINT Furniture_PK PRIMARY KEY (Furniture_ID);


-- Foreign keys (FK)
ALTER TABLE Room ADD CONSTRAINT Room_FK FOREIGN KEY (Hostel_ID) REFERENCES Hostel(Hostel_ID);
ALTER TABLE Student ADD CONSTRAINT Student_FK FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID);
ALTER TABLE Technique ADD CONSTRAINT Technique_FK FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID);
ALTER TABLE Furniture ADD CONSTRAINT Furniture_FK FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID);


-- Candidate keys (CK)
ALTER TABLE Room ADD CONSTRAINT Room_number_unique UNIQUE (room_number, Hostel_ID);
ALTER TABLE Room MODIFY (room_number);
ALTER TABLE Room MODIFY (Hostel_ID);



-- CHECK
ALTER TABLE Hostel ADD CONSTRAINT Hostel_rating_bounds_0to10
	CHECK (rating >= 0 AND rating <= 10);
ALTER TABLE Technique ADD CONSTRAINT Technique_fridge_0or1		-- Bool
	CHECK (fridge = 0 OR fridge = 1);
ALTER TABLE Technique ADD CONSTRAINT Technique_microwave_0or1	-- Bool
	CHECK (microwave = 0 OR microwave = 1);
ALTER TABLE Technique ADD CONSTRAINT Technique_TV_0or1			-- Bool
	CHECK (TV = 0 OR TV = 1);


