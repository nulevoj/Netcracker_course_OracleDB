
ALTER TABLE Hostel ADD CONSTRAINT Hostel_rating_bounds_0to10
	CHECK (rating >= 0 AND rating <= 10);


/*

Code	Line / Position		Description
L029	1 / 24				Keywords should not be used as identifiers.
L004	2 / 1				Incorrect indentation type found in file.
L003	2 / 2				Expected 0 indentations, found 1 [compared to line 01]
L014	2 / 9				Unquoted identifiers must be consistently pascal case.
L014	2 / 25				Unquoted identifiers must be consistently pascal case.

*/
