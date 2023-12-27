# The name of this view in Looker is "Customer"
view: customer {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker-private-demo.video_store.customer` ;;
  drill_fields: [customer_id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Active" in Explore.

  dimension: active {
    type: number
    sql: ${TABLE}.active ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_active {
    type: sum
    sql: ${active} ;;
    drill_fields: [detail*]
  }

  measure: average_active {
    type: average
    sql: ${active} ;;
    drill_fields: [detail*]
  }

  measure: total_inactive {
    type: number
    sql: ${count} - ${total_active} ;;
    drill_fields: [detail*]
  }

  measure: customer_retention {
    type: number
    sql: (${count} - ${total_inactive})/${count};;
    value_format_name: percent_2
  }

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: create {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.create_date ;;
  }

  dimension: days_since_customer_created {
    type: number
    sql: DATE_DIFF(CURRENT_DATE(),${create_date}, DAY) ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    #required_access_grants: [can_see_emails]
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.last_update ;;
  }

  dimension: store_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.store_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  customer_id,
  last_name,
  first_name,
  store.store_id,
  rental.count,
  payment.count
  ]
  }

}
