 (define (problem seat-groups)
 
 (:domain restaurant-optimization)
 
 (:objects 
	group1with2 
	group2with4 
	group3with4 
	group4with6 
	group5with6
	group6with3 
	group7with2  - group 
	
	table1 
	table2 
	table3
	table4
	table5
	table6 - table 
	
	anj
	ana
	ariana
	kat - staff
	
	nadir
	raouf - chef)
	
 (:init (= (group-size group1with2) 2)
 (= (group-size group2with4) 4)
 (= (group-size group3with4) 4)
 (= (group-size group4with6) 6)
 (= (group-size group5with6) 6)
 (= (group-size group6with3) 3)
 (= (group-size group7with2) 2)
 
 (= (table-size table1) 2)
 (= (table-size table2) 4)
 (= (table-size table3) 6)
 (= (table-size table4) 6)
 (= (table-size table5) 3)
 (= (table-size table6) 2)
 
 (= (table-id table1) 1)
 (= (table-id table2) 2)
 (= (table-id table3) 3)
 (= (table-id table4) 4)
 (= (table-id table5) 5)
 (= (table-id table6) 6)
 
 (waiting-to-be-seated group1with2)
 (waiting-to-be-seated group2with4)
 (waiting-to-be-seated group3with4)
 (waiting-to-be-seated group4with6)
 (waiting-to-be-seated group5with6)
 (waiting-to-be-seated group6with3)
 (waiting-to-be-seated group7with2)
 
 (table-available table1)
 (table-available table2)
 (table-available table3)
 (table-available table4)
 (table-available table5)
 (table-available table6)
 
 (staff-available anj)
 (staff-available ana)
 (staff-available ariana)
 (staff-available kat)

)

 (:goal (and (group-done group1with2)
 (group-done group2with4)
 (group-done group3with4)
 (group-done group4with6)
 (group-done group5with6)
 (group-done group6with3)
 (group-done group7with2)
 )
 )
 (:metric minimize (total-time))
 )