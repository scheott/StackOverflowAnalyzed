CREATE TABLE CombinedData AS
SELECT 
    Q.*, 
    A.Id AS AnswerId, A.UserId AS AnswerUserId, A.CreationDate AS AnswerCreationId, 
    A.CreationDate AS AnswerCreationDate, A.Score AS AnswerScore, A.Body AS AnswerBody,
    T.Tag
FROM Questions Q
LEFT JOIN Answers A ON Q.Id = A.ParentId
LEFT JOIN Tags T ON Q.Id = T.Id;
