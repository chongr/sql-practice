


DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,

  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  assoc_author INTEGER NOT NULL,

  FOREIGN KEY (assoc_author) REFERENCES users(id)
);

DROP TABLE IF EXISTS questions_follows;

CREATE TABLE questions_follows (
  u_id INTEGER,
  q_id INTEGER,

  FOREIGN KEY (u_id) REFERENCES users(id),
  FOREIGN KEY (q_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  q_id INTEGER NOT NULL,
  parent_id INTEGER,
  u_id INTEGER NOT NULL,
  body TEXT NOT NULL,


  FOREIGN KEY (q_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (u_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS questions_likes;

CREATE TABLE questions_likes (
  ul_id INTEGER,
  ql_id INTEGER,

  FOREIGN KEY (ul_id) REFERENCES users(id),
  FOREIGN KEY (ql_id) REFERENCES questions(id)
);

INSERT INTO
  questions (title, body, assoc_author)
VALUES
  ("How to SQL", "How do i SQL", 1),
  ("How to not SQL", "how do i stop SQLing", 1),
  ("When i s lunch?", "I am hungry when is lunch", 1);

INSERT INTO
  users (fname, lname)
VALUES
  ("Bob", "Robert"),
  ("John", "Johnson"),
  ("Fred", "Frederickson");

INSERT INTO
  replies (q_id, parent_id, u_id, body)
VALUES
  (1, NULL, 1, "???????"),
  (1, 1, 2, "who is typing all the question marks?"),
  (1, 2, 2, "double post sorry"),
  (1, 1, 3, "lol u guys are weird"),
  (1, 1, 3, "lol i am weird"),
  (2, NULL, 3, "I am hungry");

  INSERT INTO
    questions_follows (u_id, q_id)
  VALUES
    (1,1),
    (2, 1),
    (3, 2);

  INSERT INTO
    questions_likes (ul_id, ql_id)
  VALUES
    (3,1),
    (1, 1),
    (3, 2);
