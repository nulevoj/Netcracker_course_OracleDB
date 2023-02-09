
ALTER TABLE Hostel ADD CONSTRAINT Hostel_rating_bounds_0to10
CHECK (Rating >= 0 AND Rating <= 10);

-- (ignore L029)
