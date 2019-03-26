(define(domain restaurant-staff-optimization))
        (:requirements :typing :durative-actions)
        (:types table staff group chef)
        (:predicates
            (table-available ?t - table)
            (staff-hand-free ?s - staff)
            (staff-available ?s - staff)
            (chef-available ?c - chef)
            (waiting-to-be-seated ?g - group)
            (seated ?g - group ?t - table)
            (decide-beverage ?g - group ?t - table)
            (ready-to-order-beverage ?g - group ?t - table)
            (ordered-beverage ?g - group ?t - table ?s - staff)
            (made-beverage ?c - chef)
            (served-beverage? g-group ?b - beverage ?s - staff)
            (decide-food ?g - group ?t-table)
            (ready-to-order-food ?g - group ?t - table)
            (ordered-food ?g - group ?t - table ?s - staff)
            (made-food ?c - chef)
            (served-food ?g - group ?s - staff)
            (food-eaten ?g - group)
            (decide-dessert ?g - group ?t-table)
            (ready-to-order-dessert ?g -group ?t - table)
            (ordered-dessert ?g - group ?t - table ?s - staff)
            (made-dessert ?c - chef)
            (served-dessert ?g - group ?s - staff)
            (dessert-eaten ?g -group)
            (ready-to-pay ?g - group)
            (given-bill ?s - staff ?t - table)
            (paid ?g -group)
            (left ?g -group)
            (table-empty ?t - table)
            (table-dirty ?t - table)
            (table-clean ?t - table ?s - staff)
        )
        (:functions
            (group-size ?g -group)
            (table-size ?t -table)
            (table-id ?t - table)
            (staff-id ?s - staff)
        )
        
        (:durative-action seatGroup
            :parameters (?s - staff ?g - group ?t - table)
            :duration(= ?duration 360)
            :condition (and (at start (waiting-to-be-seated ?g))
                 (over all (table-available ?t))
                 (at start (table-clean ?t))
                 (at start (staff-available ?s))
                 (at start (<= (group-size ?g) (table-size ?t)))
                                 )
            :effect (and (at start(not (staff-available ?s)))
                    (at end ((seated ?g ?t)))
                    (at end (staff-available ?s))
              (at end (not (table-available ?t)))
                            )
        )

        (:durative-action decideBeverage
                :parameters(?g - group ?t - table)
                :duration (= ?duration 300)
                :condition (and (at start (group-seated ?g)))
                :effect (and (at end (ready-to-order-beverage ?g ?t)))
                )


        (:durative-action takeBeverageOrder
            :parameters (?t - table ?s - staff ?g - group)
            :duration (= ?duration (* (group-size ?g) 20))
            :condition (and (at start (ready-to-order-beverage ?g ?t))
                                  (at start (group-seated ?g ?t))
                                   (at start (staff-available ?s))
                                 )
            :effect (and (at start (not (staff-available ?s)))
                       (at end (staff-available ?s))
                       (at end (ordered-beverages ?g ?t))
                            )
        )

        (:durative-action makeBeverage
         :parameters (?g - group ?c - chef ?t - table)
         :duration (= ?duration (* (group-size ?g) 180))
         :condition (and (at start (ordered-beverage ?g ?t))
                  (at start (chef-available ?c))
         )
        :effect (and (at start (not (chef-available ?c)))
                        (at end (chef-available ?c))
                        (at end (made-beverage ?c))
                )
        )

        (:durative-action giveBeverage
            :parameters (?t - table ?g - group ?s-staff ?c - chef)
            :duration (= ?duration (* (group-size ?g) 5))
            :condition (and (at start (staff-available ?s))
                        (at start(ordered-beverages ?g ?t))
                        (at start (made-beverage ?c))
                )
            :effect (and (at start (not (staff-available ?s)))
                            (at end (served-beverages ?g ?t))
                            (at end (staff-available ?s))
                            (at end (ready-to-order-food ?g ?t))
                )
        )

        (:durative-action takeFoodOrder
            :parameters (?t - table ?s - staff ?g - group)
            :duration (= ?duration (* (group-size ?g) 20))
            :condition (and (at start (ready-to-order-food ?g ?t))
                                (at start (group-seated ?g ?t))
                                (at start (staff-available ?s))
                )
            :effect (and (at start (not (staff-available ?s)))
                       (at end (staff-available ?s))
                       (at end (ordered-food ?g ?t))
                )
        )

        (:durative-action makeFood
                :parameters (?c - chef ?g - group ?t - table)
                :duration (= ?duration 900)
                :condition (and (at start (ordered-food ?g ?t))
                                (at start (chef-available ?c))
                )
                :effect (and (at start (not (chef-available ?c)))
                        (at end (chef-available ?c))
                        (at end (made-food ?c))
                )
        )

        (:durative-action giveFood
                :duration (= ?duration (* (group-size ?g) 7))
                :parameters (?t- table ?g-group ?s-staff)
                :condition (and (at start (staff-available ?s))
                                (at start (made-food ?c))
                                )
                :effect (and (at start (not (staff-available ?s)))
                        (at end (served-food ?g ?s))
                        (at end (staff-available ?s))
                )
        )

        (:durative-action eatFood
                :duration (= ?duration 1200)
                :parameters (?t- table ?g-group)
                :condition (and (and (at start (served-food ?g ?t))))
                :effect (and (at end (food-eaten ?g ?s)))
        )

        (:durative-action decideDessertOrder
                :duration (= ?duration 1800)
                :parameters (?g - group ?t - table)
                :condition (and (at start (food-eaten ?g ?t)))
                :effect (and (at end (ready-to-order-dessert ?g ?t)))
        )

        (:durative-action takeDessertOrder
                :duration (= ?duration (* (group-size ?g) 10))
                :parameters (?t - table ?g - group ?s - staff)
                :condition (and (at start (staff-available?s))
        (at start  (ready-to-order-dessert ?g ?t))
        :effect (and (at start (not (staff-available)))
        (at end (staff-available ?s)
        (at end (ordered-dessert ?g ?t))))

        (:durative-action makeDessert
                :duration (= ?duration 10)
                :parameters (?c - chef)
                :condition (and (at start (ordered-dessert ?g ?t))
                                (at start (chef-available ?c))
                )
                :effect (and (at start (not (chef-available ?c)))
                        (at end (chef-available ?c))
                        (at end (made-dessert ?c))
                )
        )

        (:durative-action giveDessert
                :duration (= ?duration (* (group-size ?g) 7))
                :parameters (?t - table ?g - group ?s - staff)
                :condition (and (at start (made-dessert ?c))
                                (at start (staff-available ?s))
                )
                :effect (and (at start (not (staff-available ?s)))
                                (at end (staff-available ?s))
                                (at end (served-dessert ?g?s))
                )
        )

        (:durative-action eatDessert
                :duration (= ?duration 600)
                :parameters (?t - table ?g - group ?s - staff)
                :condition (and (at start (served-dessert ?g ?s)))
                :effect (at end (dessert-eaten ?g?t))
        )

        (:durative-action askBill
                :duration (= ?duration 5)
                :parameters (?t - table ?g - group ?s - staff)
                :condition (and (at start (dessert-eatent ?g?t))
                                (at start (not (staff-available ?s)))
                                (at end (staff-available ?s))
                )
        )

        (:durative-action giveBill
                :duration(= ?duration 240)
                :parameters (?t - table?g - group ?s - staff)
                :condition (and (at start (staff-available ?s))
                                (at start (bill-asked ?g ?t)))
                :effect (and (at start (not (staff-available ?s)))
                                (at end (staff-available ?s)
                                (at end (paid ?g))
                                (at end (left ?g))
                                (at end (table-empty ?t))
                                (at end (table-dirty ?t)))
                )
        )

        (:durative-action cleanTable
                :duration (= ?duration 300)
                :parameters (?t - table ?s - staff)
                :condition(and (at start (table-dirty ?t))
                                (at start (table-empty ?t))
                                (at start (staff-available ?s))
                )
                :effect (and (at start (not (staff-available)))
                                (at end (staff-available ?s))
                                (at end (table-cleaned ?t))
                        )
        )
