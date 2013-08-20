#MBTableManager

A simple state machine for table views.

Useful when:

1. For example, you have a view with a segmented control and a table view. When the first segment is selected, the table displays certain data, and when the second segment is selected, the table view displays different data. The table manager in this case manages this state in an object oriented manner, keeping your code clean of clunky if else statements and state instance variables.

2. Your table has a special row that is active only at certain points. For example, you press a "+" button, which inserts a new row at the top of your table with a text field. After you're done editing the text field, that cell disappears. The table manager here manages this state info for you.

Demo coming soon.