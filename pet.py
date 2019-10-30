import sqlite3 as db
from datetime import datetime
date = str(datetime.now())

def init():
    '''
    Initialize a new database to store the expenditures
    '''
    conn = db.connect('pet.db')
    cur = conn.cursor()
    sql = '''
    create table if not exists expenses (
        amount number,
        category string,
        description string,
        date string
    )
    '''
    cur.execute(sql)
    conn.commit()

def log(category, description, amount):
    conn = db.connect('pet.db')
    cur = conn.cursor()
    sql = '''
    insert into pet values (
        '{}',
        '{}',
        '{}',
        {}
    )
    '''.format(date, category, description, amount)
    cur.execute(sql)
    conn.commit()

def view(category = None):
    conn = db.connect('expense.db')
    cur = conn.cursor()
    if category:
        sql = '''
        select * from expense where category = '{}'
        '''.format(category)
        sql2 = '''
        select sum(amount) from expense where category = '{}'
        '''.format(category)
    else:
        sql = '''
        select * from expense 
        '''
        sql2 = '''
        select sum(amount) from expense 
        '''
    cur.execute(sql)
    result = cur.fetchall()
    cur.execute(sql2)
    total =  cur.fetchone()[0]

    return result, total
    #conn.commit()

print(view())
