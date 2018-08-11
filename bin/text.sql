drop table bonus;
drop table dept;
drop table emp;
drop table salgrade;
CREATE TABLE BONUS (
		ENAME VARCHAR(10),
		JOB VARCHAR(9),
		SAL integer,
		COMM integer
	);

CREATE TABLE DEPT (
		DEPTNO numeric(2 , 0) NOT NULL,
		DNAME VARCHAR(14),
		LOC VARCHAR(13),
		primary key (DEPTNO)
	);

CREATE TABLE SALGRADE (
		GRADE integer,
		LOSAL integer,
		HISAL integer
	);

CREATE TABLE EMP (
		EMPNO numeric(4 , 0) NOT NULL,
		ENAME VARCHAR(10),
		JOB VARCHAR(9),
		MGR numeric(4 , 0),
		HIREDATE DATE,
		SAL numeric(7 , 2),
		COMM numeric(7 , 2),
		DEPTNO numeric(2 , 0),
		primary key (EMPNO)
	);

	begin transaction;
	insert into dept values (10,'ACCOUNTING','NEW YORK');
	insert into dept values (20,'RESEARCH','DALLAS');
	insert into dept values (30,'SALES','CHICAGO');
	insert into dept values (40,'OPERATIONS','BOSTON');
	commit;
	
	select * from dept;

	begin transaction;
	insert into salgrade values (1,700,1200);
	insert into salgrade values (2,1201,1400);
	insert into salgrade values (3,1401,2000);
	insert into salgrade values (4,2001,3000);
	insert into salgrade values (5,3001,9999);
	commit;
	select * from salgrade;
	
	begin transaction;
	insert into emp values (7369,'SMITH','CLERK',7902,'1980-12-17',800,null,20);
	insert into emp values (7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30);
	insert into emp values (7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30);
	insert into emp values (7566,'JONES','MANAGER',7839,'1981-04-02',2975,NULL,20);
	insert into emp values (7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30);
	insert into emp values (7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,null,30);
	insert into emp values (7782,'CLARK','MANAGER',7839,'1981-06-09',2450,null,10);
	insert into emp values (7788,'SCOTT','ANALYST',7566,'1987-04-19',3000,NULL,20);
	insert into emp values (7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,null,10);
	insert into emp values (7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30);
	insert into emp values (7876,'ADAMS','CLERK',7788,'1987-05-23',1100,null,20);
	insert into emp values (7900,'JAMES','CLERK',7698,'1981-12-03',950,NULL,30);
	insert into emp values (7902,'FORD','ANALYST',7566,'1981-12-03',3000,null,20);
	insert into emp values (7934,'MILLER','CLERK',7782,'1982-01-23',1300,null,10);
	commit;
	select * from emp;
	
	--工资大于3000的员工
	select * from emp where (select coalesce(comm,0)+sal) > 3000;
	select * from emp where sal>3000;
	
	--以S开头的所有员工
	select * from emp where ename like 'S%';
	
	--名字是SMITH,ALLEN,FORD员工
	select * from emp where ename = 'SMITH' or ename = 'ALLEN' or ename = 'FORD';
	
	--雇佣日期早于1982-1-1的所有员工且工资小于3000元的员工
	select * from emp where sal < 3000 and hiredate < '1982-1-1';
	
	--按工资降序排列，工资相同按雇佣日期升序排列
	select * from emp order by sal desc,hiredate asc;
	
	--统计各部门的平均工资
	select deptno,avg(sal) as 平均工资 from emp group by deptno;
	
	--公司工资最高的人
	select max(sal) from emp;
	
	
	--统计出各部门工资最多的人
	select *
	from emp as p1 right join 
		(select deptno ,max(sal)as maxsal from emp group by deptno) as p2
	on p1.sal = p2.maxsal;
	
	
	--统计出各部门大于等于平均工资的人
	select deptno,avg(sal) as 平均工资 from emp group by deptno;
	
	select *
	from emp as emp1 right join dept
	on  dept.deptno = emp1.deptno
	where sal > (select avg(sal) as 平均工资 from emp as emp2 where emp1.deptno = emp2.deptno group by deptno);
	
	
	--查询出所有是经理的员工和部门编号
--	select max(empno) as em from emp group by mgr;
	select distinct a.mgr as 部门编号,b.ename as 经理名字
	from emp as a,emp as b
	where a.mgr = b.empno;
	
	select distinct a.mgr,b.ename from emp a,emp b where a.mgr=b.empno;
	
	--查询出某一经理员工下的所有员工
--	select max(empno)as 经理,count(*) as 直接管理人数 from emp group by mgr;
----	having (select count(*) from emp group by mgr)=0;
--	with A as (select max(empno)as 经理,count(*) as 直接管理人数 from emp group by mgr)
--	select *
--	from emp left join A
--	on emp.empno=a.经理;
--	where 经理=emp.empno is not null 直接管理人数+A.直接管理人数;
--		
--	select deptno,count(sal),
--	from emp
--	where mgr = 7839;

	--查询出每位员工的工资等级
	--标量子查询
	select ename,sal,
		(select grade as 等级 from salgrade where sal between losal and hisal)
	from emp;
	
	
	--每个人的经理是谁
	select p1.ename,
		(select ename as 经理 from emp where empno = p1.mgr)
	from emp as p1;
	
	
	--求平均工资最高的部门的部门编号和部门名称
	with A as (select avg(sal) as avgsal,deptno from emp group by deptno)
	select * 
	from A left join dept
	on A.deptno = dept.deptno
	where A.avgsal = (select max(avgsal) from A);
	
	
	--求工资高于公司平均工资的员工
	select * from emp
	where sal > (select avg(sal) as 平均工资 from emp);
	
	
	--求工资最高的员工姓名和工资
	select *from emp 
	where sal = (select max(sal) from emp);
	
	
	--统计出各部门大于等于平均工资的人
	select deptno,avg(sal) as 平均工资 from emp group by deptno;
	
	select *
	from emp as emp1 right join dept
	on  dept.deptno = emp1.deptno
	where sal > (select avg(sal) as 平均工资 from emp as emp2 where emp1.deptno = emp2.deptno group by deptno);
	

	--求平均工资最高的部门的部门编号和部门名称
	with A as (select avg(sal) as avgsal,deptno from emp group by deptno)
	select * 
	from A left join dept
	on A.deptno = dept.deptno
	where A.avgsal = (select max(avgsal) from A);
	
	--列出各部门工资最高的员工信息
	select *
	from emp as p1 right join 
		(select deptno ,max(sal)as maxsal from emp group by deptno) as p2
	on p1.sal = p2.maxsal;
	
	SELECT * FROM EMP E1 WHERE E1.SAL=(SELECT MAX(SAL) FROM EMP E2 WHERE E1.DEPTNO=E2.DEPTNO);--老师
	
	--求工资高于公司平均工资的员工
	select * from emp
	where sal > (select avg(sal) as 平均工资 from emp);
	
	--求工资高于所在部门的平均工资的员工
	select *
	from emp as emp1 right join dept
	on  dept.deptno = emp1.deptno
	where sal > (select avg(sal) as 平均工资 from emp as emp2 where emp1.deptno = emp2.deptno group by deptno);
	
	--求平均工资的级别最低的部门名称
	select a.deptno,a.avgsal,
		(select grade from salgrade where a.avgsal between losal and hisal)
		from (select avg(sal) as avgsal,deptno from emp group by deptno) as a;
	
	with B as (select a.deptno,a.avgsal,
		(select grade from salgrade where a.avgsal between losal and hisal) 
		from (select avg(sal) as avgsal,deptno from emp group by deptno) as a)
	select *
	from B right join dept 
	on B.deptno = dept.deptno
	where B.grade = (select min(grade) from B);
	
	--求比普通员工最高工资高的经理员工姓名
	with a as(select distinct a.mgr as empno,b.ename,b.sal from emp as a,emp as b where a.mgr = b.empno)
	select * from a
	where sal > 
		(select max(sal) as maxsal from emp where empno not in (select empno from a));
	
	--求工资最高的前5名员工姓名
	select * from emp
	order by sal desc limit 5 ;
		
	--求工资最高的前6-10名员工姓名
	select * from emp
	order by sal desc limit 5 OFFSET 5;
	
	--列出各部门平均工资及对应的工资等级
	select a.deptno,a.avgsal,
		(select grade from salgrade where a.avgsal between losal and hisal)
	from (select avg(sal) as avgsal,deptno from emp group by deptno) as a;
	
	--求经理员工中平均工资的最低的部门名称
	select distinct a.mgr as empno,b.mgr,b.ename,b.sal,b.deptno from emp as a,emp as b where a.mgr = b.empno--经理员工
	
	with A as (select avg(p.sal) as avgsal,p.deptno 
		from (select distinct a.mgr as empno,b.sal,b.deptno 
			from emp as a,emp as b where a.mgr = b.empno) as p 
		group by deptno)
	select *
	from A right join dept
	on a.deptno = dept.deptno
	where avgsal = (select max(avgsal) from A);