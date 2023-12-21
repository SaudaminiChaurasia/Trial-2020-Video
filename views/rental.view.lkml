# The name of this view in Looker is "Rental"
view: rental {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker-private-demo.video_store.rental` ;;
  drill_fields: [rental_id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: rental_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.rental_id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Customer ID" in Explore.

  dimension: customer_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: inventory_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_id ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: last_update {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.last_update ;;
  }

  dimension_group: rental {
    type: time
    timeframes: [raw, time, date, week, month, month_name, quarter, year]
    sql: ${TABLE}.rental_date ;;
  }

  dimension_group: return {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.return_date ;;
  }

  dimension: is_rental_returned {
    case: {
      when: {
        sql: ${return_date} IS NOT NULL ;;
        label: "Returned"
      }
      else: "With Customer"
    }
  }

  dimension: rental_return_in_days {
    type: number
    sql: DATE_DIFF(${return_date},${rental_date}, DAY) ;;
  }

  dimension: late_return {
    type:  yesno
    sql: ${rental_return_in_days} > 7 ;;
  }

  dimension: staff_id {
    type: number
    sql: ${TABLE}.staff_id ;;
  }

  measure: total_late_returns {
    hidden: yes
    type: sum
    sql: if(${late_return},1,0) ;; #to add late returns
  }

  measure: total_returns {
    hidden: yes
    type: count_distinct
    sql: ${return_date} ;;
  }

  measure: late_return_rate {
    type: number
    value_format_name: percent_2
    sql: ${total_late_returns}/${total_returns} ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  rental_id,
  inventory.inventory_id,
  customer.last_name,
  customer.customer_id,
  customer.first_name,
  payment.count
  ]
  }

}
