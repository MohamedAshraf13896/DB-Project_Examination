
GO
ALTER procedure [dbo].[CorrectExam] (@stdId as int,@examId as int)
as
begin
	declare @sum as decimal
	select @sum = sum(q.ques_grade)
	from Questions q inner join Std_ans s
	on q.ques_id = s.ques_id
	where q.exam_id = @examId and s.st_id = @stdId and s.std_ans = q.right_ans;

	declare @FullGrade as decimal
	select @FullGrade = c.exam_Full_Grade
	from Course c where c.crs_id = @examId

	update Crs_student set st_grade = @sum/@FullGrade*100
	where Crs_id = @examId and st_id = @stdId
end

go

create PROCEDURE [dbo].[Add_Question] @qType char(5),@rAns int,@qGrade int,@qHeader nvarchar(150),@qBody nvarchar(150),@cid int
, @firstChoice nvarchar(200),@secondChoice nvarchar(200), @thirdChoice nvarchar(200),@fourthChoice nvarchar(200)

AS

Begin try
BEGIN TRAN

INSERT INTO Questions VALUES(@qType,@rAns,@qGrade,@qHeader,@qBody,@cid,Null);
IF @qType = 'TF'
Begin
INSERT INTO Ques_Choice VALUES(SCOPE_IDENTITY(),1,@firstChoice),(SCOPE_IDENTITY(),2,@secondChoice);
End
ELSE
Begin
INSERT INTO Ques_Choice VALUES(SCOPE_IDENTITY(),1,@firstChoice),(SCOPE_IDENTITY(),2,@secondChoice),
(SCOPE_IDENTITY(),3,@thirdChoice),(SCOPE_IDENTITY(),4,@fourthChoice);
End

COMMIT TRAN
end try
begin catch
	rollback tran
end catch


create procedure Stud_Regis_Crs @crs_id int
as
select s.*
from Student s
where s.st_id not in (select st_id from Crs_student where Crs_id=@crs_id)