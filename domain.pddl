 (define (domain restaurant-staff-optimization)
 
 (:requirements :typing :durative-actions :fluents)
 
 (:types group table staff - object)
 
 (:predicates
 (waiting-to-be-seated ?g - group)
 (table-available ?t - table)
 (staff-available ?s - staff)
 (chef-available ?c - chef)
 
 (group-seated ?g - group ?t - table)
 (decide-food ?g - group)
 (ordered-food ?g - group ?t - table)
  
 (served-food ?g - group)
 (not-served-food ?g - group)

 (food-eaten ?g - group)
 (table-dirty ?t - table ?g - group)
 (group-done ?g -group)
 )
 
 (:functions
 (group-size ?g - group)
 (table-size ?t - table)
 (table-id ?t - table)
 )
 
 (:durative-action seat_group
 :parameters (?s - staff ?g - group ?t - table)
 :duration (= ?duration 20)
 :condition (and (at start (waiting-to-be-seated ?g))
 (over all (table-available ?t))
 (at start (staff-available ?s))
 (at start (<= (group-size ?g) (table-size ?t)))
 )
 :effect (and (at start (not (staff-available ?s)))
 (at end (staff-available ?s))
 (at end (group-seated ?g ?t))
 (at end (staff-available ?s))
 (at end (not (table-available ?t)))
 (at end (not-served-food ?g))
 (at end (not (waiting-to-be-seated ?g)))
 )
 )
 
 ;After seating group, they are allotted 60 seconds per person to decide their order 
 (:durative-action decide_food_order
 :parameters (?g - group ?t - table)
 :duration (= ?duration (* (group-size ?g) 60))
 :condition (and (over all (not-served-food ?g))
 (over all (group-seated ?g ?t))
 )
 :effect (at end (decide-food ?g))
 )

 ;40 seconds per person to order
(:durative-action take_food_order
 :parameters (?s - staff ?g - group ?t - table)
 :duration (= ?duration (* (group-size ?g) 40))
 :condition (and (at start (staff-available ?s))
 (at start (group-seated ?g ?t))
 (at start (decide-food ?g))
 )
 :effect (and (at start (not (staff-available ?s)))
 (at end (staff-available ?s))
 (at end (ordered-food ?g ?t))
 )
 )
 
 
 ;All food for the group prepared and 120 seconds taken to serve per person
 (:durative-action serve_food
 :parameters (?s - staff ?g - group ?t - table)
 :duration (= ?duration (* (group-size ?g) 120))
 :condition (and (at start (group-seated ?g ?t))
 (at start (ordered-food ?g ?t))
 (at start (not-served-food ?g))
 (at start (staff-available ?s))
 )
 :effect (and (at start (not (not-served-food ?g)))
 (at end (served-food ?g))
 (at start (not (staff-available ?s)))
 (at end (staff-available ?s))
 )
 )

 
 (:durative-action let_group_eat
 :parameters (?g - group)
 :duration (= ?duration (* (group-size ?g) 1500))
 :condition (at start (served-food ?g))
 :effect (at end (food-eaten ?g))
 )
 
 (:durative-action take_payment
 :parameters (?s - staff ?g - group ?t - table)
 :duration (= ?duration (* (group-size ?g) 50) )
 :condition (and (at start (group-seated ?g ?t))
 (at start (staff-available ?s))
 (at start (food-eaten ?g))
 )
 :effect (and (at start (not (group-seated ?g ?t)))
 (at start (not (staff-available ?s)))
 (at end (staff-available ?s))
 (at end (table-dirty ?t ?g))
 )
 )

 (:durative-action clean_table
 :parameters (?s - staff ?g - group ?t - table)
 :duration (= ?duration 120)
 :condition (and (at start (staff-available ?s))
 (at start (table-dirty ?t ?g))
 )
 :effect (and (at start (not (group-seated ?g ?t)))
 (at end (table-available ?t))
 (at start (not (staff-available ?s)))
 (at end (staff-available ?s))
 (at end (group-done ?g))
 (at end (not (table-dirty ?t ?g)))
 )
 )
 )
 
