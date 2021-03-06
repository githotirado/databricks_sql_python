-- MSSQL Query
-- places hackers table in an outside join
select sd.*, name
from
    (
        select sd1.submission_date,
                (
                    select count(distinct hacker_id)
                    from submissions as sd2
                    where sd2.submission_date = sd1.submission_date
                        and (
                                select count(distinct sd3.submission_date)
                                from submissions as sd3
                                where sd3.submission_date < sd2.submission_date
                                        and sd2.hacker_id = sd3.hacker_id                    
                            ) = datediff(Day, '2016-03-01', sd2.submission_date)
                ) as hacker_count,
                (
                    select hacker_id
                    from submissions as sd4
                    where sd4.submission_date = sd1.submission_date
                    group by hacker_id
                    order by count(hacker_id) desc, hacker_id asc
                    offset 0 rows fetch next 1 row only   
                ) as max_hacker_id
        from 
            (
                select distinct submission_date
                from submissions
            ) as sd1
    ) as sd
    inner join hackers as ha
        on sd.max_hacker_id = ha.hacker_id
order by sd.submission_date asc;

----------------  Third attempt at solving (works too)
-- with submission_table as (
--     select s.submission_date, s.hacker_id, count(*) as submissions_count
--     from submissions as s
--         inner join hackers as h
--             on s.hacker_id = h.hacker_id
--     group by s.submission_date, s.hacker_id 
-- )
select sd1.submission_date,
        (
            select count(distinct hacker_id)
            from submissions as sd2
            where sd2.submission_date = sd1.submission_date
                and (select count(distinct sd3.submission_date)
                     from submissions as sd3
                     where sd3.submission_date < sd2.submission_date
                            and sd2.hacker_id = sd3.hacker_id                    
                    ) = datediff(Day, '2016-03-01', sd2.submission_date)
        ),
        (
             select hacker_id
             from submissions as sd4
             where sd4.submission_date = sd1.submission_date
             group by hacker_id
             order by count(hacker_id) desc, hacker_id asc
             offset 0 rows fetch next 1 row only   
        ) as max_hacker_id,
        (
            select name
            from submissions as sd5
                inner join hackers as ha
                    on sd5.hacker_id = ha.hacker_id
            where sd5.submission_date = sd1.submission_date
            group by sd5.hacker_id, name
            order by count(sd5.hacker_id) desc, sd5.hacker_id asc
            offset 0 rows fetch next 1 row only
        ) as hacker_name
from (select distinct submission_date from submissions) as sd1
order by sd1.submission_date asc




