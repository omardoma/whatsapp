
SELECT add_user_to_group_chat(1, '01000000001', '01000000004');
SELECT * FROM GROUP_CHAT_MEMBERS

SELECT remove_user_from_group_chat(1, '01000000001', '01000000004');
SELECT * FROM GROUP_CHAT_MEMBERS

SELECT add_admin_to_group_chat(1, '01000000001', '01000000003');
SELECT * FROM GROUP_CHAT_MEMBERS

SELECT remove_admin_from_group_chat(1, '01000000001', '01000000003');
SELECT * FROM GROUP_CHAT_MEMBERS