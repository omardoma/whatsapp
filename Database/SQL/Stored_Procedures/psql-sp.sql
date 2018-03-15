-- Procedure to report a user
CREATE OR REPLACE FUNCTION report_user(reporter_mobile_number VARCHAR(70), reported_mobile_number VARCHAR(70))
RETURNS void AS $$
BEGIN
  INSERT INTO reported VALUES (reporter_mobile_number, reported_mobile_number);
END;
$$ LANGUAGE plpgsql;

-- Procedure to block a user
CREATE OR REPLACE FUNCTION block_user(blocker_mobile_number VARCHAR(70), blocked_mobile_number VARCHAR(70))
RETURNS void AS $$
BEGIN
  INSERT INTO blocked VALUES (blocker_mobile_number, blocked_mobile_number);
END;
$$ LANGUAGE plpgsql;

-- Procedure to add a new user
CREATE OR REPLACE FUNCTION insert_user(mobile_number VARCHAR(20), display_name VARCHAR(100), 
    display_picture TEXT, user_status TEXT, verification_code VARCHAR(10))
RETURNS void AS $$
BEGIN
  INSERT INTO users
    (mobile_number ,display_name , display_picture, user_status, verification_code )
   VALUES
    (mobile_number , display_name , display_picture , user_status, verification_code);
END;
$$ LANGUAGE plpgsql;

-- Procedure to update all the user data at once given that the mobile number
CREATE OR REPLACE FUNCTION update_user(user_number VARCHAR(20), display_name , display_picture, user_status)
RETURNS void AS $$
BEGIN
  UPDATE users SET
    (display_name , display_picture, user_status)
   =
    (display_name , display_picture , user_status)
   WHERE
     mobile_number LIKE user_number 
       
END;
$$ LANGUAGE plpgsql;

-- Procedure to update the user's name given that the mobile number
CREATE OR REPLACE FUNCTION update_user_name(user_number VARCHAR(20), display_name)
RETURNS void AS $$
BEGIN
  UPDATE users SET
    (display_name)
   =
    (display_name)
   WHERE
     mobile_number LIKE user_number 
       
END;
$$ LANGUAGE plpgsql;

-- Procedure to update the user's display_picture given that the mobile number
CREATE OR REPLACE FUNCTION update_user_picture(user_number VARCHAR(20), display_picture)
RETURNS void AS $$
BEGIN
  UPDATE users SET
    (display_picture)
   =
    (display_picture)
   WHERE
     mobile_number LIKE user_number 
       
END;
$$ LANGUAGE plpgsql;

-- Procedure to update the user's user_status given that the mobile number
CREATE OR REPLACE FUNCTION update_user_status(user_number VARCHAR(20), user_status)
RETURNS void AS $$
BEGIN
  UPDATE users SET
    (user_status)
   =
    (user_status)
   WHERE
     mobile_number LIKE user_number 
       
END;
$$ LANGUAGE plpgsql;

-- Procedure to verify a user given that the mobile number
CREATE OR REPLACE FUNCTION verify_user(user_number VARCHAR(20))
RETURNS void AS $$
BEGIN
  UPDATE users SET
    (verified)
   =
    (TRUE)
   WHERE
     mobile_number LIKE user_number 
       
END;
$$ LANGUAGE plpgsql;

-- Procedure to get the previous chats of user given that user_number
CREATE OR REPLACE FUNCTION get_chats(user_number VARCHAR(20)) 
RETURNS refcursor AS $$
  DECLARE
    ref refcursor;
  BEGIN
    OPEN ref FOR 
      SELECT * FROM chats 
      WHERE 
        mobile_number 
          LIKE 
        user_number;
    RETURN ref;
  END;
  $$ LANGUAGE plpgsql;



------------------------------------------- Admin Procedures -------------------------------------------



-- Procedure to let an admin add a user to a group chat
CREATE OR REPLACE FUNCTION add_user_to_group_chat(group_id INT, admin_number VARCHAR(20), user_number VARCHAR(20))
RETURNS void AS $$
BEGIN

  INSERT INTO GROUP_CHAT_MEMBERS (
    group_chat_id,
    mobile_number,
    is_archived,
    is_admin,
    join_at,
    left_at
  )
  SELECT
    group_id, user_number, FALSE, FALSE, NOW(), NULL

  WHERE EXISTS (
    SELECT * 
    FROM GROUP_CHAT_MEMBERS
    WHERE group_chat_id = group_id AND mobile_number LIKE admin_number AND is_admin = TRUE
  );

END;
$$ LANGUAGE plpgsql;


-- Procedure to let an admin add another admin to a group chat
CREATE OR REPLACE FUNCTION add_admin_to_group_chat(group_id INT, admin_number VARCHAR(20), other_admin_number VARCHAR(20))
RETURNS void AS $$
BEGIN

  INSERT INTO GROUP_CHAT_MEMBERS (
    group_chat_id,
    mobile_number,
    is_archived,
    is_admin,
    join_at,
    left_at
  )
  SELECT
    group_id, other_admin_number, FALSE, TRUE, NOW(), NULL

  WHERE EXISTS (
    SELECT * 
    FROM GROUP_CHAT_MEMBERS
    WHERE group_chat_id = group_id AND mobile_number LIKE admin_number AND is_admin = TRUE
  );

END;
$$ LANGUAGE plpgsql;


-- Procedure to let an admin remove a user from a group chat
CREATE OR REPLACE FUNCTION remove_user_from_group_chat(group_id INT, admin_number VARCHAR(20), user_number VARCHAR(20))
RETURNS void AS $$
BEGIN

  DELETE FROM GROUP_CHAT_MEMBERS
  WHERE EXISTS (
    SELECT * 
    FROM GROUP_CHAT_MEMBERS
    WHERE group_chat_id = group_id AND mobile_number LIKE admin_number AND is_admin = TRUE
  )
  AND mobile_number LIKE user_number;

END;
$$ LANGUAGE plpgsql;


-- Procedure to let an admin remove another admin from a group chat
CREATE OR REPLACE FUNCTION remove_admin_from_group_chat(group_id INT, admin_number VARCHAR(20), other_admin_number VARCHAR(20))
RETURNS void AS $$
BEGIN

  DELETE FROM GROUP_CHAT_MEMBERS
  WHERE EXISTS (
    SELECT * 
    FROM GROUP_CHAT_MEMBERS
    WHERE group_chat_id = group_id AND mobile_number LIKE admin_number AND is_admin = TRUE
  )
  AND mobile_number LIKE other_admin_number AND is_admin = TRUE;

END;
$$ LANGUAGE plpgsql;