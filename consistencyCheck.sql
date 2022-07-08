  SELECT w_id, w_ytd
  FROM warehouse a
  LEFT JOIN (
    SELECT d_w_id, sum(d_ytd) 
    FROM district 
    GROUP BY d_w_id) b (d_w_id, d_ytd_sum)
  ON b.d_w_id = a.w_id and b.d_ytd_sum = a.w_ytd
  WHERE b.d_w_id is null;

SELECT d_w_id, d_id, minus_one FROM ( SELECT d_w_id, d_id, D_NEXT_O_ID - 1 AS minus_one FROM district ) a LEFT JOIN ( SELECT o_w_id, o_d_id, max(o_id) FROM orders GROUP BY o_w_id, o_d_id) b (o_w_id, o_d_id, o_id_max) ON a.d_w_id = b.o_w_id and a.d_id = b.o_d_id and a.minus_one = b.o_id_max WHERE b.o_w_id is null;

  SELECT d_w_id, d_id, minus_one
  FROM (
    SELECT d_w_id, d_id, D_NEXT_O_ID - 1 AS minus_one
    FROM district
    ) a
  LEFT JOIN (
    SELECT no_w_id, no_d_id, max(no_o_id) 
    FROM new_orders 
    GROUP BY no_w_id, no_d_id) b (no_w_id, no_d_id, no_o_id_max)
  ON a.d_w_id = b.no_w_id and a.d_id = b.no_d_id and a.minus_one = b.no_o_id_max
  WHERE b.no_w_id is null;

SELECT * FROM ( SELECT (count(no_o_id)-(max(no_o_id)-min(no_o_id)+1)) AS diff FROM new_orders GROUP BY no_w_id, no_d_id ) a WHERE diff != 0;

SELECT o_w_id, o_d_id, cnt_sum FROM ( SELECT o_w_id, o_d_id, sum(o_ol_cnt) AS cnt_sum FROM orders GROUP BY o_w_id, o_d_id) a LEFT JOIN ( SELECT ol_w_id, ol_d_id, count(ol_o_id) FROM order_line GROUP BY ol_w_id, ol_d_id ) b (ol_w_id, ol_d_id, id_count) ON a.o_w_id = b.ol_w_id and a.o_d_id = b.ol_d_id and a.cnt_sum = b.id_count WHERE b.ol_w_id is null;

SELECT d_w_id, ytd_sum FROM ( SELECT d_w_id, sum(d_ytd) AS ytd_sum FROM district GROUP BY d_w_id ) a LEFT JOIN ( SELECT w_id, w_ytd FROM warehouse ) b ON a.d_w_id = b.w_id and a.ytd_sum = b.w_ytd WHERE b.w_id is null;
