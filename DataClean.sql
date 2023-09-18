-- Remove Rows with Missing Values
DELETE FROM CombinedData WHERE Title IS NULL;

-- Delete rows where the answer is NULL
DELETE FROM CombinedData WHERE AnswerBody IS NULL;

-- Remove Duplicates
DELETE FROM CombinedData
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM CombinedData
    GROUP BY Id, AnswerId, Tag
);

-- Trim
UPDATE CombinedData
SET Title = TRIM(Title),
    Body = TRIM(Body),
    AnswerBody = TRIM(AnswerBody);

-- Normalize Date
UPDATE CombinedData
SET Title = LOWER(Title),
    Body = LOWER(Body),
    AnswerBody = LOWER(AnswerBody);

-- Filter Scores below 0
DELETE FROM CombinedData WHERE Score < 0;

-- Filter Bad Date Data points
UPDATE CombinedData
SET ClosedDate = NULL
WHERE ClosedDate IS NOT NULL AND ClosedDate < CreationDate;

-- Handle Duplicate Tags 
WITH CTE_Tags AS (
    SELECT Id, GROUP_CONCAT(Tag, ',') as AggregatedTags
    FROM CombinedData
    GROUP BY Id
)
UPDATE CombinedData
SET Tag = (SELECT AggregatedTags FROM CTE_Tags WHERE CTE_Tags.Id = CombinedData.Id);

-- Remove unnecessary rows after aggregating tags
DELETE FROM CombinedData
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM CombinedData
    GROUP BY Id, AnswerId
);
