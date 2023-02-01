create database Library

create table Books
(
Id int identity primary key,
Name nvarchar(100) check(Len(name)>2) NOT NULL,
PageCount int check (PageCount>10)
)

create table Authors
(
Id int identity primary key,
Name nvarchar(100)  NOT NULL,
SurName nvarchar(100)  NOT NULL,
)
Create table BooksAuthors
(
Id int identity primary key,
BookId int foreign key references Books(id),
AuthorId int foreign key references Authors(id),
)

insert into Books
values
('The Great Gatsby',218),
('To Kill a Mockingbird',281),
('The Lord of the Rings',1178),
('One Hundred Years of Solitude',417),
('The Dangerous Book for Boys ',249),
('The Mammoth Book of Short Crime Stories',530)

insert into Authors
values
('Agatha','Christie'),
('Arthur','Conan Doyle'),
('Conn','Iggulden'),
('Scott','Fitzgerald'),
('John Ronald','Reuel Tolkien'),
('Hal','Iggulden'),
('Gabriel','Marquez'),
('Harper','Lee')

create View usv_GetBookDetails
as
select Books.Id,Books.Name,Books.PageCount, (Authors.Name+' '+Authors.SurName) as [AuthorFullName]from 
Books
Full join 
BooksAuthors
on Books.Id=BooksAuthors.BookId 
Full join
Authors
on Authors.Id=BooksAuthors.AuthorId

select * from usv_GetBookDetails

create procedure usp_GetBooksByNameOrAuthorName
@value nvarchar(100)
as
begin
	select Books.Id,Books.Name,Books.PageCount, (Authors.Name+' '+Authors.SurName) as [AuthorFullName]from 
	Books
	Full join
	BooksAuthors
	on Books.Id=BooksAuthors.BookId 
	Full join
	Authors
	on Authors.Id=BooksAuthors.AuthorId
	where Authors.Name LIKE '%' + @value + '%'  or Books.Name LIKE '%' + @value + '%'  or Authors.SurName LIKE '%' + @value + '%' ;
end

exec usp_GetBooksByNameOrAuthorName 'Kill'

create procedure usp_InsertAuthor
@Name nvarchar(100),@SurName nvarchar(100)
as
begin
insert into Authors
values
(@Name,@Surname)
end

Create procedure usp_IUpdateAuthor
@Id int, @Name nvarchar(100),@SurName nvarchar(100)
as
begin
Update Authors set Authors.Name=@Name,Authors.SurName=@Surname where Authors.Id=@Id
end

exec usp_IUpdateAuthor 9, 'Namiq','Abilov'

Create procedure usp_DeleteAuthor
@Id int
as
begin
delete from Authors where Authors.Id=@Id 
end

exec usp_DeleteAuthor 9


create View usv_GetAuthorDetails
as
select Authors.Id,(Authors.Name+' '+Authors.SurName)as AuthorsFullName,COUNT(*)as BookCount,SUM(Books.PageCount)as MaxPageCount from BooksAuthors 
join
Authors
on
Authors.Id=BooksAuthors.AuthorId
join
Books
on Books.Id=BooksAuthors.BookId
Group By Authors.Id,Authors.Id,(Authors.Name+' '+Authors.SurName)





