/* 수업전 컬럼확인용 */
select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;
DESC salgrade;
/*23/06/23*/
/*EQUI JOIN*/
SELECT s.studno, s.name, s.deptno, d.dname, d.loc
FROM student s, department d
WHERE s.deptno = d.deptno;
/*EQUI JOIN - NATURAL JOIN*/
SELECT s.studno, s.name, deptno, d.dname, d.loc
FROM student s NATURAL JOIN department d;
/*NATURAL JOIN 사용예 (공통 칼럼은 별명을 제외) */
SELECT p.profno, p.name, deptno, d.dname
FROM professor p NATURAL JOIN department d;
/*JOIN ~ USING 절을 이용한 EQUI JOIN*/
SELECT s.studno, s.name, deptno, d.dname, d.loc
FROM student s JOIN department d USING (deptno);
/*NON-EQUI JOIN : 두 개의 테이블 간에 칼럼 값들이 서로 정확하게 일치하지 않는 경우에 사용*/
SELECT p.profno, p.name, p.sal, s.grade
FROM professor p, salgrade s
WHERE p.sal BETWEEN s.losal AND s.hisal;
/*NON-EQUI JOIN 사용예*/
SELECT p.profno, p.name, p.sal, s.grade
FROM professor p, salgrade s
WHERE p.sal BETWEEN s.losal AND s.hisal
AND p.deptno = 101;

/*OUTER JOIN : 조인 조건문에서 NULL이 출력되는 테이블 칼럼에(+) 추가*/
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.deptno = p.deptno(+)
ORDER BY p.profno;
/*학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수 이름, 직급과 출력
 단, 지도교수가 배정되지 않은 학생명단과 지도학생이 배정되지 않은 교수 명단도 함께출력*/
/*OUTER JOIN*/
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
UNION
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno;
/*LEFT OUTER JOIN : FROM 절의 왼쪽에 위치한 테이블이 NULL을 가질 경우에 사용*/
/*RIGHT OUTER JOIN : FROM 절의 오른쪽에 위치한 테이블이 NULL을 가질 경우에 사용*/
/*FULL OUTER JOIN : LEFT OUTER JOIN과 RIGHT OUTER JOIN을 동시에 실행 결과를 출력*/
SELECT studno, s.name, s.profno, p.name
FROM student s
FULL OUTER JOIN professor p ON s.profno = p.profno;
/*SELF JOIN : 하나의 테이블내에 있는 칼럼끼리 연결하는 조인이 필요한 경우 사용*/
SELECT dept.dname || '의 소속은 ' || org.dname
FROM department dept, department org
WHERE dept.college = org.deptno;

SELECT dept.dname || '의 소속은 ' || org.dname
FROM department dept JOIN department org
    ON dept.college = org.deptno;

/*서브쿼리 : 하나의 SQL명령문의 결과를 다른 SQL 명령문에 전달하기 위해 두개 이상의 SQL명령문을
            하나의 SQL명령문으로 연결하여 처리하는 방법*/
/*사용예: 교수테이블에서 '전은지' 교수와 직급이 동일한 모든 교수 이름 검색*/
SELECT name, position
FROM professor
WHERE position = (SELECT position
                  FROM professor
                  WHERE name = '전은지');
AND name LIKE '전%'; /*전씨 성을 가진 교수만 출력*/

/*단일행 서브쿼리 : 서브쿼리에서 단 하나의 행만을 검색하여 메인쿼리에 반환하는 질의문*/
/*사용예 - 사용자 아이디가 'jun123'인 학생과 같은 학년인 학생의 학변, 이름, 학년을 출력*/
SELECT studno, name, grade
FROM student
WHERE grade = (SELECT grade
               FROM student
               WHERE userid = 'jun123');
/*문제 : 사용자아이디가 'jun123'인 학생과 같은 학년인 학번,이름,학년,학과이름,학과위치를 출력*/               
SELECT s.studno, s.name, s.grade, d.dname, d.loc
FROM student s, department d
WHERE s.deptno = d.deptno
AND grade = (SELECT grade
             FROM student
             WHERE userid = 'jun123');               

/*'<'연산자를 이용한 사용예
     101번 학과 학생들의 평균 몸무게보다 몸무게가 적은 학생의 이름, 학과번호, 몸무게를 출력*/               
SELECT name, deptno, weight
FROM student
WHERE weight < (SELECT AVG(weight)
                FROM student
                WHERE deptno = 101)
ORDER BY deptno;
/*문제 : 학과별 평균몸무게가 최대인 학과번호와 평균몸무게를 출력*/
SELECT deptno 학과번호, AVG(weight) 최대몸무게
FROM student
GROUP BY deptno
HAVING AVG(weight) = (SELECT MAX(AVG(weight))
                      FROM student
                      GROUP BY deptno);
/*실습예 : 20101번 학생과 학년이 같고, 키는 20101번 학생보다 큰 학생으 이름 학년 키를 출력*/
SELECT name, grade, height
FROM student
WHERE grade = (SELECT grade
               FROM student
               WHERE studno = 20101)
AND height > (SELECT height
              FROM student
              WHERE studno = 20101);
              
/*다중행 서브쿼리 : 서브쿼리에서 반환되는 결과 행이 하나 이상일 때 사용하는 서브쿼리*/
/*IN 연산자를 이용한 다중행 서브쿼리 : 메인쿼리의 비교조건에서 서브쿼리의 출력결과와 하나라도 일치하면 메인쿼리 조건절이 참이되는 연산자
  사용 예 : 정보미디어학부에 소속된 모든 학생의 학번, 이름, 학과번호를 출력*/
SELECT name, grade, deptno
FROM student
WHERE deptno IN (SELECT deptno
                 FROM department
                 WHERE college = 100);
/*문제 : 사원테이블을 조회하여 각 부서별로 최대 급여를 받는 사원들의 부서번호, 이름, 급여를 출력*/
SELECT e.deptno, e.ename, e.sal, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal IN (SELECT MAX(sal)
               FROM emp
               GROUP BY deptno)
ORDER BY deptno;

/*ANY 연산자를 이용한 다중행 서브쿼리 : 메인쿼리의 비교조건에서 서브쿼리의 출력결과와 하나라도 일치하면 메인쿼리 조건절이 참이되는 연산자
  사용예 : 모든 학생중에서 4학년 학생중에서 키가제일 작은 학생보다 키가큰 학생의 학번,이름,키를 출력*/
SELECT studno, name, height
FROM student
WHERE height > ANY (SELECT height
                    FROM student
                    WHERE grade = '4');
/*ALL연산자를 이용한 다중행 서브쿼리 : 메인쿼리의 비교조건에서 서브쿼리의 검색 결과와 모두 일치하면 메인쿼리 조건절이 참이되는 연산자
사용예 : 모든 학생 중에서 4학년 학생 중에서 키가 가장 큰 학생보다 키가 큰 학생의 학번,이름,키를 출력하라*/                    
SELECT studno, name, height
FROM student
WHERE height > ALL (SELECT height
                    FROM student
                    WHERE grade = '4');
/*EXISTS연산자를 이용한 다중행 서브쿼리
  - 서브쿼리에서 검색된 결과가 하나라도 존재하면 메인쿼리 조건절이 참이되는 연산자
  - 서브쿼리에서 검색된 결과가 존재하지 않으면 메인쿼리의 조건절은 거짓
사용예 :  */                    
SELECT profno, name, sal, comm, SAL+NVL(comm, 0)
FROM professor
WHERE EXISTS (SELECT profno
              FROM professor
              WHERE comm IS NOT NULL);
/*NOT EXISTS연산자를 이용한 다중행 서브쿼리 
  - EXISTS와 상반되는 연산자
  - 서브쿼리에서 검색된 결과가 하나도 존재하지 않으면 메인쿼리의 조건절이 참이되는 연산자
사용예 : 학생중에서 'goodstudent'이라는 사용자 아이디가 없으면 1을 출력하여라*/ 
SELECT 1 userid_exist
FROM dual
WHERE NOT EXISTS (SELECT userid
                  FROM student
                  WHERE userid = 'goodstudent');
                  
/*다중 컬럼 서브쿼리
  - 서브쿼리에서 여러개의 칼럼 값을 검색하여 메인쿼리의 조건절과 비교하는 서브쿼리
  - 메인쿼리의 조건절에서도 서브쿼리의 칼럼 수만큼 지정해야함
  - 종류 : PAIRWISE, UNPALRWISE */                
/*PAIRWISE 다중 컬럼 서브쿼리 : 칼럼을 쌍으로 묶어서 동시에 비교하는 방식
  - 메인쿼리와 서브쿼리에서 비교하는 칼럼의 수는 반드시 동일해야함.
  사용예 : PAIRWISE 비교방법에 의해 학년별로 몸무게가 최소인 학생의 이름,학년,몸무게를 출력하라*/
SELECT name, grade, weight
FROM student
WHERE (grade, weight) IN (SELECT grade, MIN(weight)
                          FROM student
                          GROUP BY grade);
/*문제 : 각 학과별로 입사일이 가장 오래된 교수의 교수번호와 이름, 입사일, 학과명을 출력 (입사일 순 정렬)*/
SELECT p.profno "교수 NO.", p.name 교수명, p.hiredate 입사일, d.dname 학과
FROM professor p, department d
WHERE p.deptno = d.deptno
AND p.hiredate IN (SELECT MIN(hiredate) 
                   FROM professor
                   GROUP BY deptno);                 
/*UNPALRWISE 다중칼럼 서브쿼리 : 칼럼별로 나누어서 비교한 후, AND 연산을 하는 방식
  - 각 칼럼이 동시에 만족하지 않더라도 개별적으로 만족하는 경우에는 비교조건이 참이 되어 결과를 출력 가능
사용예 : UNPALRWISE 비교 방법에 의해 학년별로 몸무게가 최소인 학생의 이름, 학년, 몸무게를 출력*/
SELECT name, grade, weight
FROM student
WHERE grade IN (SELECT grade
                FROM student
                GROUP BY grade)
AND weight IN (SELECT MIN(weight)
               FROM student
               GROUP BY grade);
               
/*상호연관 서브쿼리 : 메인쿼리절과 서브쿼리간에 검색결과를 교환하는 서브쿼리*/
/*실습*/
SELECT ename, hiredate
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE INITCAP(ename) = 'Blake');

SELECT empno, ename, sal
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp)
ORDER BY sal desc;

/*Scalar 서브쿼리*/

/*데이터 조작어 : 테이블에 새로운 데이터를 입력하거나 기존데이터를 수정또는 삭제하기 위한 명령어*/
/*데이터 입력 : 테이블에 데이터를 입력하기 위한 명령인 INSERT 명령문 사용*/
/*단일 행 입력 : 한번에 하나의 행을 테이블에 입력하는 방법*/
/*단일 행 입력 예 : 학생테이블에 홍길동 학생의 데이터를 입력하여라*/
INSERT INTO student
VALUES(10110, '홍길동', 'hong', '1', '8501011143098', '85/01/01', '041)630-314', 170, 70, 101, 9903);

SELECT studno, name
FROM student
WHERE studno = 10110;

/*NULL입력 : 데이터를 입력하는 시점에서 해당 컬럼 값을 모르거나, 미확정*/
/*묵시적으로 NULL 입력하는 예
  INSERT 명령문에서 묵시적인 방법을 이용하여 부서 테이블의 부서번호와 부서
  이름을 입력하고 나머지 칼럼은 NULL을 입력하여라*/
INSERT INTO department(deptno, dname)
VALUES (300, '생명공학부');

COMMIT;

SELECT *
FROM DEPARTMENT
WHERE deptno = 300;
/*명시적으로 NULL을 입력하는 예
INSERT 명령문에서 명시적인 방법을 이용하여 부서 테이블의 부서번호와 부서이름을
입력하고 나머지 칼럼은 NULL을 입력*/
INSERT INTO department
VALUES (301, '환경보건학과', '','');

SELECT *
FROM DEPARTMENT
WHERE deptno = 301;

/*날짜데이터 입력방법 : */
/*날짜 형식 입력하는 예
교수테이블에서 입사일을 2006년 1월1일로 입력하라*/
INSERT INTO professor(profno, name, position, hiredate, deptno)
VALUES (9920, '최윤식', '조교수',
        TO_DATE('2006/01/01', 'YYYY/MM/DD'), 102);
COMMIT;
SELECT *
FROM professor
WHERE profno = 9920;

/*SYSDATE 함수를 이용한 현재 날짜 입력
사용예 */
INSERT INTO professor
VALUES (9910, '백미선', 'white', '전임강사', 200, SYSDATE, 10, 101);
COMMIT;
SELECT *
FROM professor
WHERE profno = 9910;

/*다중행 입력 : INSERT 명령문에서 서브쿼리 절을 이용*/
/*단일 테이블에 다중 행 입력*/
/*사용법(테이블의 데이터를 복사할 경우)*/
CREATE TABLE T_STUDENT
AS SELECT *
FROM STUDENT
WHERE 1=0;

INSERT INTO T_STUDENT
INSERT INTO T_STUDENT
SELECT * FROM STUDENT

commit;

SELECT * FROM T_STUDENT

/*다중행 입력 INSERT ALL :*/
CREATE TABLE height_info (
seudno number(5),
name varchar2(10),
height number(5,2));

CREATE TABLE weight_info (
seudno number(5),
name varchar2(10),
height number(5,2));
/*INSERT ALL 사용예 : */
INSERT ALL
INTO height_info VALUES (studno, name, height)
INTO weight_info VALUES (studno, name, weight)
SELECT studno, name, height, weight
FROM student
WHERE grade >= '2';

COMMIT;

SELECT *
FROM height_info;
SELECT *
FROM weight_info;

/*Conditional INSERT ALL*/
DELETE FROM height_info;
DELETE FROM weight_info;

COMMIT;
/*Conditional INSERT ALL 
사용예 : 학생테이블에서 2학년 이상의 학생을 검색하여 height_info테이블에는 키가 170보다 큰 학생의 학번,이름,키를
weight_info 테이블에는 몸무게가 70보다 큰 학생의 학번, 이름, 몸무게를 각각 입력하여라*/
INSERT ALL
WHEN height > 170 THEN
    INTO height_info VALUES (studno, name, height)
WHEN weight > 70 THEN
    INTO weight_info VALUES (studno, name, weight)
SELECT studno, name, height, weight
FROM student
WHERE grade >= '2';

/*Conditional-First INSERT*/
DELETE FROM height_info;
DELETE FROM weight_info;

COMMIT;
/*Conditional-First INSERT
 사용예 : */
INSERT FIRST
WHEN height > 170 THEN
    INTO height_info VALUES (studno, name, height)
WHEN weight > 70 THEN
    INTO weight_info VALUES (studno, name, weight)
SELECT studno, name, height, weight
FROM student
WHERE grade >= '2';

SELECT * FROM weight_info;
SELECT * FROM height_info;

DELETE FROM student WHERE name = '홍길동';
/*오후 문제풀이*/
/* 1. 학과별 학생수가 최대인 학과번호와 학생 수를 출력하세요.
  학과번호     학생수
 ----------    ----------
       101          8 */
SELECT s.deptno 학과번호, d.dname 학과명, count(*) 학생수
FROM student s, department d
WHERE s.deptno = d.deptno
GROUP BY d.dname, s.deptno
HAVING COUNT(s.studno) = (SELECT MAX(count(*))
                          FROM student
                          GROUP BY deptno);      
/* ####2,3번은 employees, departments , locations 테이블을 이용하세요.
2. Sales부서에 근무하는 사원에 대해 last_name, job_id, 부서번호, 부서이름을 last_name 순으로 출력하세요.(결과-34건)
LAST_NAME       JOB_ID     DEPARTMENT_ID DEPARTMENT_NAME
--------------- ---------- ------------- ----------------
Abel            SA_REP                80 Sales
Ande            SA_REP                80 Sales
Banda           SA_REP                80 Sales
Bates           SA_REP                80 Sales */
SELECT e.LAST_NAME, e.JOB_ID, e.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM employees e, departments d
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
AND d.DEPARTMENT_NAME='Sales'
ORDER BY e.LAST_NAME;

/* 3. oxford에서 근무하는 모든 사원에 대해 last_name, job, 부서번호, 부서이름, 부서위치(city)를 출력하세요.(결과-34건)
LAST_NAME       JOB_ID     DEPARTMENT_ID DEPARTMENT_NAME
--------------- ---------- ------------- -----------------
Russell         SA_MAN                80 Sales
Partners        SA_MAN                80 Sales
Errazuriz       SA_MAN                80 Sales
Cambrault       SA_MAN                80 Sales
Zlotkey         SA_MAN                80 Sales
Tucker          SA_REP                80 Sales
Bernstein       SA_REP                80 Sales
Hall            SA_REP                80 Sales
Olsen           SA_REP                80 Sales */

SELECT e.LAST_NAME, e.JOB_ID, e.DEPARTMENT_ID, d.DEPARTMENT_NAME, l.CITY
FROM employees e, departments d, locations l
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
AND d.LOCATION_ID = l.LOCATION_ID
AND l.CITY = 'Oxford';`