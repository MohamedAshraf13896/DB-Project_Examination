
create proc [dbo].[getExamChoices] @Exam_id  int 
as
select c.* 
from Questions q join Ques_Choice c
on q.ques_id = c.ques_id
where exam_id = @Exam_id