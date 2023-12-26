connection: "looker-private-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#access_grant: access_grant_name {
#user_attribute: user_attribute_name
#allowed_values: [ "value_1", "value_2" , ... ]
#}
# explore: order_items {
#access_filter: {
#  field: fully_scoped_field
#  user_attribute: user_attribute_name
#}
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
access_grant: can_see_emails {
  user_attribute: can_see_emails
  allowed_values: ["yes"]
}

explore: rental {
  access_filter: {
    field: customer.store_id
    user_attribute: storeid
  }
  join: inventory {
    type: left_outer
    relationship: many_to_one
    sql_on: ${rental.inventory_id} = ${inventory.inventory_id} ;;
  }
  join: film {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory.film_id} = ${film.film_id} ;;
  }
  join: film_category {
    type: left_outer
    relationship: one_to_one
    sql_on: ${film.film_id} = ${film_category.film_id} ;;
  }
  join: category {
    type: left_outer
    relationship: many_to_one
    sql_on: ${film_category.category_id} = ${category.category_id} ;;
  }
  join: customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.customer_id} = ${rental.customer_id} ;;
  }
  join: staff_list {
    type: left_outer
    relationship: many_to_one
    sql_on: ${staff_list.sid} = ${rental.staff_id} ;;
  }
  join: payment {
    type: left_outer
    relationship: one_to_one
    sql_on: ${rental.rental_id} = ${payment.rental_id} ;;
  }
  join: store {
    type: left_outer
    relationship: many_to_one
    sql_on: ${store.store_id} = ${customer.store_id} ;;
  }
}
