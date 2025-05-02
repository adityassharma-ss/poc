SELECT 
    s.sid, s.serial#, s.username, s.osuser, s.status, s.program
FROM 
    v$session s
JOIN 
    v$locked_object l ON s.sid = l.session_id
JOIN 
    dba_objects o ON l.object_id = o.object_id
WHERE 
    o.object_name = 'IFLOCL14';



ALTER SYSTEM KILL SESSION 'SID,SERIAL#' IMMEDIATE;


ALTER SYSTEM KILL SESSION '123,45678' IMMEDIATE;

