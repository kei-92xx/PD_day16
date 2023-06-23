/* ������ �÷�Ȯ�ο� */
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
/*NATURAL JOIN ��뿹 (���� Į���� ������ ����) */
SELECT p.profno, p.name, deptno, d.dname
FROM professor p NATURAL JOIN department d;
/*JOIN ~ USING ���� �̿��� EQUI JOIN*/
SELECT s.studno, s.name, deptno, d.dname, d.loc
FROM student s JOIN department d USING (deptno);
/*NON-EQUI JOIN : �� ���� ���̺� ���� Į�� ������ ���� ��Ȯ�ϰ� ��ġ���� �ʴ� ��쿡 ���*/
SELECT p.profno, p.name, p.sal, s.grade
FROM professor p, salgrade s
WHERE p.sal BETWEEN s.losal AND s.hisal;
/*NON-EQUI JOIN ��뿹*/
SELECT p.profno, p.name, p.sal, s.grade
FROM professor p, salgrade s
WHERE p.sal BETWEEN s.losal AND s.hisal
AND p.deptno = 101;

/*OUTER JOIN : ���� ���ǹ����� NULL�� ��µǴ� ���̺� Į����(+) �߰�*/
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.deptno = p.deptno(+)
ORDER BY p.profno;
/*�л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, �������� �̸�, ���ް� ���
 ��, ���������� �������� ���� �л���ܰ� �����л��� �������� ���� ���� ��ܵ� �Բ����*/
/*OUTER JOIN*/
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
UNION
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno;
/*LEFT OUTER JOIN : FROM ���� ���ʿ� ��ġ�� ���̺��� NULL�� ���� ��쿡 ���*/
/*RIGHT OUTER JOIN : FROM ���� �����ʿ� ��ġ�� ���̺��� NULL�� ���� ��쿡 ���*/
/*FULL OUTER JOIN : LEFT OUTER JOIN�� RIGHT OUTER JOIN�� ���ÿ� ���� ����� ���*/
SELECT studno, s.name, s.profno, p.name
FROM student s
FULL OUTER JOIN professor p ON s.profno = p.profno;
/*SELF JOIN : �ϳ��� ���̺��� �ִ� Į������ �����ϴ� ������ �ʿ��� ��� ���*/
SELECT dept.dname || '�� �Ҽ��� ' || org.dname
FROM department dept, department org
WHERE dept.college = org.deptno;

SELECT dept.dname || '�� �Ҽ��� ' || org.dname
FROM department dept JOIN department org
    ON dept.college = org.deptno;

/*�������� : �ϳ��� SQL��ɹ��� ����� �ٸ� SQL ��ɹ��� �����ϱ� ���� �ΰ� �̻��� SQL��ɹ���
            �ϳ��� SQL��ɹ����� �����Ͽ� ó���ϴ� ���*/
/*��뿹: �������̺��� '������' ������ ������ ������ ��� ���� �̸� �˻�*/
SELECT name, position
FROM professor
WHERE position = (SELECT position
                  FROM professor
                  WHERE name = '������');
AND name LIKE '��%'; /*���� ���� ���� ������ ���*/

/*������ �������� : ������������ �� �ϳ��� �ุ�� �˻��Ͽ� ���������� ��ȯ�ϴ� ���ǹ�*/
/*��뿹 - ����� ���̵� 'jun123'�� �л��� ���� �г��� �л��� �к�, �̸�, �г��� ���*/
SELECT studno, name, grade
FROM student
WHERE grade = (SELECT grade
               FROM student
               WHERE userid = 'jun123');
/*���� : ����ھ��̵� 'jun123'�� �л��� ���� �г��� �й�,�̸�,�г�,�а��̸�,�а���ġ�� ���*/               
SELECT s.studno, s.name, s.grade, d.dname, d.loc
FROM student s, department d
WHERE s.deptno = d.deptno
AND grade = (SELECT grade
             FROM student
             WHERE userid = 'jun123');               

/*'<'�����ڸ� �̿��� ��뿹
     101�� �а� �л����� ��� �����Ժ��� �����԰� ���� �л��� �̸�, �а���ȣ, �����Ը� ���*/               
SELECT name, deptno, weight
FROM student
WHERE weight < (SELECT AVG(weight)
                FROM student
                WHERE deptno = 101)
ORDER BY deptno;
/*���� : �а��� ��ո����԰� �ִ��� �а���ȣ�� ��ո����Ը� ���*/
SELECT deptno �а���ȣ, AVG(weight) �ִ������
FROM student
GROUP BY deptno
HAVING AVG(weight) = (SELECT MAX(AVG(weight))
                      FROM student
                      GROUP BY deptno);
/*�ǽ��� : 20101�� �л��� �г��� ����, Ű�� 20101�� �л����� ū �л��� �̸� �г� Ű�� ���*/
SELECT name, grade, height
FROM student
WHERE grade = (SELECT grade
               FROM student
               WHERE studno = 20101)
AND height > (SELECT height
              FROM student
              WHERE studno = 20101);
              
/*������ �������� : ������������ ��ȯ�Ǵ� ��� ���� �ϳ� �̻��� �� ����ϴ� ��������*/
/*IN �����ڸ� �̿��� ������ �������� : ���������� �����ǿ��� ���������� ��°���� �ϳ��� ��ġ�ϸ� �������� �������� ���̵Ǵ� ������
  ��� �� : �����̵���кο� �Ҽӵ� ��� �л��� �й�, �̸�, �а���ȣ�� ���*/
SELECT name, grade, deptno
FROM student
WHERE deptno IN (SELECT deptno
                 FROM department
                 WHERE college = 100);
/*���� : ������̺��� ��ȸ�Ͽ� �� �μ����� �ִ� �޿��� �޴� ������� �μ���ȣ, �̸�, �޿��� ���*/
SELECT e.deptno, e.ename, e.sal, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal IN (SELECT MAX(sal)
               FROM emp
               GROUP BY deptno)
ORDER BY deptno;

/*ANY �����ڸ� �̿��� ������ �������� : ���������� �����ǿ��� ���������� ��°���� �ϳ��� ��ġ�ϸ� �������� �������� ���̵Ǵ� ������
  ��뿹 : ��� �л��߿��� 4�г� �л��߿��� Ű������ ���� �л����� Ű��ū �л��� �й�,�̸�,Ű�� ���*/
SELECT studno, name, height
FROM student
WHERE height > ANY (SELECT height
                    FROM student
                    WHERE grade = '4');
/*ALL�����ڸ� �̿��� ������ �������� : ���������� �����ǿ��� ���������� �˻� ����� ��� ��ġ�ϸ� �������� �������� ���̵Ǵ� ������
��뿹 : ��� �л� �߿��� 4�г� �л� �߿��� Ű�� ���� ū �л����� Ű�� ū �л��� �й�,�̸�,Ű�� ����϶�*/                    
SELECT studno, name, height
FROM student
WHERE height > ALL (SELECT height
                    FROM student
                    WHERE grade = '4');
/*EXISTS�����ڸ� �̿��� ������ ��������
  - ������������ �˻��� ����� �ϳ��� �����ϸ� �������� �������� ���̵Ǵ� ������
  - ������������ �˻��� ����� �������� ������ ���������� �������� ����
��뿹 :  */                    
SELECT profno, name, sal, comm, SAL+NVL(comm, 0)
FROM professor
WHERE EXISTS (SELECT profno
              FROM professor
              WHERE comm IS NOT NULL);
/*NOT EXISTS�����ڸ� �̿��� ������ �������� 
  - EXISTS�� ��ݵǴ� ������
  - ������������ �˻��� ����� �ϳ��� �������� ������ ���������� �������� ���̵Ǵ� ������
��뿹 : �л��߿��� 'goodstudent'�̶�� ����� ���̵� ������ 1�� ����Ͽ���*/ 
SELECT 1 userid_exist
FROM dual
WHERE NOT EXISTS (SELECT userid
                  FROM student
                  WHERE userid = 'goodstudent');
                  
/*���� �÷� ��������
  - ������������ �������� Į�� ���� �˻��Ͽ� ���������� �������� ���ϴ� ��������
  - ���������� ������������ ���������� Į�� ����ŭ �����ؾ���
  - ���� : PAIRWISE, UNPALRWISE */                
/*PAIRWISE ���� �÷� �������� : Į���� ������ ��� ���ÿ� ���ϴ� ���
  - ���������� ������������ ���ϴ� Į���� ���� �ݵ�� �����ؾ���.
  ��뿹 : PAIRWISE �񱳹���� ���� �г⺰�� �����԰� �ּ��� �л��� �̸�,�г�,�����Ը� ����϶�*/
SELECT name, grade, weight
FROM student
WHERE (grade, weight) IN (SELECT grade, MIN(weight)
                          FROM student
                          GROUP BY grade);
/*���� : �� �а����� �Ի����� ���� ������ ������ ������ȣ�� �̸�, �Ի���, �а����� ��� (�Ի��� �� ����)*/
SELECT p.profno "���� NO.", p.name ������, p.hiredate �Ի���, d.dname �а�
FROM professor p, department d
WHERE p.deptno = d.deptno
AND p.hiredate IN (SELECT MIN(hiredate) 
                   FROM professor
                   GROUP BY deptno);                 
/*UNPALRWISE ����Į�� �������� : Į������ ����� ���� ��, AND ������ �ϴ� ���
  - �� Į���� ���ÿ� �������� �ʴ��� ���������� �����ϴ� ��쿡�� �������� ���� �Ǿ� ����� ��� ����
��뿹 : UNPALRWISE �� ����� ���� �г⺰�� �����԰� �ּ��� �л��� �̸�, �г�, �����Ը� ���*/
SELECT name, grade, weight
FROM student
WHERE grade IN (SELECT grade
                FROM student
                GROUP BY grade)
AND weight IN (SELECT MIN(weight)
               FROM student
               GROUP BY grade);
               
/*��ȣ���� �������� : ������������ ������������ �˻������ ��ȯ�ϴ� ��������*/
/*�ǽ�*/
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

/*Scalar ��������*/

/*������ ���۾� : ���̺� ���ο� �����͸� �Է��ϰų� ���������͸� �����Ǵ� �����ϱ� ���� ��ɾ�*/
/*������ �Է� : ���̺� �����͸� �Է��ϱ� ���� ����� INSERT ��ɹ� ���*/
/*���� �� �Է� : �ѹ��� �ϳ��� ���� ���̺� �Է��ϴ� ���*/
/*���� �� �Է� �� : �л����̺� ȫ�浿 �л��� �����͸� �Է��Ͽ���*/
INSERT INTO student
VALUES(10110, 'ȫ�浿', 'hong', '1', '8501011143098', '85/01/01', '041)630-314', 170, 70, 101, 9903);

SELECT studno, name
FROM student
WHERE studno = 10110;

/*NULL�Է� : �����͸� �Է��ϴ� �������� �ش� �÷� ���� �𸣰ų�, ��Ȯ��*/
/*���������� NULL �Է��ϴ� ��
  INSERT ��ɹ����� �������� ����� �̿��Ͽ� �μ� ���̺��� �μ���ȣ�� �μ�
  �̸��� �Է��ϰ� ������ Į���� NULL�� �Է��Ͽ���*/
INSERT INTO department(deptno, dname)
VALUES (300, '������к�');

COMMIT;

SELECT *
FROM DEPARTMENT
WHERE deptno = 300;
/*��������� NULL�� �Է��ϴ� ��
INSERT ��ɹ����� ������� ����� �̿��Ͽ� �μ� ���̺��� �μ���ȣ�� �μ��̸���
�Է��ϰ� ������ Į���� NULL�� �Է�*/
INSERT INTO department
VALUES (301, 'ȯ�溸���а�', '','');

SELECT *
FROM DEPARTMENT
WHERE deptno = 301;

/*��¥������ �Է¹�� : */
/*��¥ ���� �Է��ϴ� ��
�������̺��� �Ի����� 2006�� 1��1�Ϸ� �Է��϶�*/
INSERT INTO professor(profno, name, position, hiredate, deptno)
VALUES (9920, '������', '������',
        TO_DATE('2006/01/01', 'YYYY/MM/DD'), 102);
COMMIT;
SELECT *
FROM professor
WHERE profno = 9920;

/*SYSDATE �Լ��� �̿��� ���� ��¥ �Է�
��뿹 */
INSERT INTO professor
VALUES (9910, '��̼�', 'white', '���Ӱ���', 200, SYSDATE, 10, 101);
COMMIT;
SELECT *
FROM professor
WHERE profno = 9910;

/*������ �Է� : INSERT ��ɹ����� �������� ���� �̿�*/
/*���� ���̺� ���� �� �Է�*/
/*����(���̺��� �����͸� ������ ���)*/
CREATE TABLE T_STUDENT
AS SELECT *
FROM STUDENT
WHERE 1=0;

INSERT INTO T_STUDENT
INSERT INTO T_STUDENT
SELECT * FROM STUDENT

commit;

SELECT * FROM T_STUDENT

/*������ �Է� INSERT ALL :*/
CREATE TABLE height_info (
seudno number(5),
name varchar2(10),
height number(5,2));

CREATE TABLE weight_info (
seudno number(5),
name varchar2(10),
height number(5,2));
/*INSERT ALL ��뿹 : */
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
��뿹 : �л����̺��� 2�г� �̻��� �л��� �˻��Ͽ� height_info���̺��� Ű�� 170���� ū �л��� �й�,�̸�,Ű��
weight_info ���̺��� �����԰� 70���� ū �л��� �й�, �̸�, �����Ը� ���� �Է��Ͽ���*/
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
 ��뿹 : */
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

DELETE FROM student WHERE name = 'ȫ�浿';
/*���� ����Ǯ��*/
/* 1. �а��� �л����� �ִ��� �а���ȣ�� �л� ���� ����ϼ���.
  �а���ȣ     �л���
 ----------    ----------
       101          8 */
SELECT s.deptno �а���ȣ, d.dname �а���, count(*) �л���
FROM student s, department d
WHERE s.deptno = d.deptno
GROUP BY d.dname, s.deptno
HAVING COUNT(s.studno) = (SELECT MAX(count(*))
                          FROM student
                          GROUP BY deptno);      
/* ####2,3���� employees, departments , locations ���̺��� �̿��ϼ���.
2. Sales�μ��� �ٹ��ϴ� ����� ���� last_name, job_id, �μ���ȣ, �μ��̸��� last_name ������ ����ϼ���.(���-34��)
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

/* 3. oxford���� �ٹ��ϴ� ��� ����� ���� last_name, job, �μ���ȣ, �μ��̸�, �μ���ġ(city)�� ����ϼ���.(���-34��)
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