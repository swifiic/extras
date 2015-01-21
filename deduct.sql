delimiter //

select count(*) OperatorLedgerEntries from OperatorLedger;

/*select UserId  USID from User where Status!='deleted';*/

drop procedure if exists deduct;
CREATE PROCEDURE deduct()
BEGIN
DECLARE n INT DEFAULT 0;
DECLARE msg varchar(1024) DEFAULT '';
DECLARE i INT DEFAULT 0;
DECLARE logId INT DEFAULT 0;
DECLARE opCt INT DEFAULT 0;
DECLARE id INT;
DECLARE total INT DEFAULT 0;
DECLARE users CURSOR  FOR SELECT UserId FROM User where Status!='deleted';

/*delete from OperatorLedger;
*/
OPEN users;
SET total=FOUND_ROWS();
      while i < total DO
        fetch users into id;
	set msg = concat(msg,' ',id);         
	insert into OperatorLedger(
	EventNotes,ReqUserId,ReqDeviceId,CreditDeviceId,DebitUserId,Details,Time,AuditLogId,AuditNotes,Amount) values
       ('Debit',1,1,null,id,'Debited from deduct script',now(),null,null,-100);
	SET i = i+1;
     end while; 
close users;
select concat('Periodic Debiting from Users with Ids : ',msg) Message;
End;
//
delimiter ;
call deduct();


