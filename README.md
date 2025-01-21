# new_year_app

С наступившим новым 2025 годом!!!

Это приложение – новогодняя открытка на которой изображена елка с подарками и анимация снегопада.

Написано на Flutter с применением CustomPainter.

### Простые фигуры

Для отрисовки фигур используется сущность `Paint`, которая представляет собой "кисточку" для которой можно указать цвет и ширину.

Фигуры отрисовываются с помощью сущности canvas. У нее есть несколько методов:
- `drawCircle()` - круг
- `drawLine()` - линия
- `drawPaint()` - заливка
- `drawPath()` - ломаная
- `drawRect()` - прямоугольник
В них нужно передать объект Paint и данные для размеров и позиционирования.

### Оптимизация

Метод `canvas.saveLayer()` нужен для того, чтобы сохранить текущее состояние рисования и создать новый слой для отрисовки. Это позволяет улучшить производительность и внешний вид графики

Метод
`bool shouldRepaint(covariant CustomPainter oldDelegate) => true;`
взывается всякий раз, когда объекту предоставляется новый экземпляр класса для рисования (CustomPainter).
Может повлиять на оптимизацию, если прописать условие и не перерисовывать каждый раз.

**RepaintBoundary** нужен для оптимизации производительности рендеринга в приложении Flutter
Когда виджет помечается как RepaintBoundary, Flutter создаёт новый слой для него в дереве виджетов. Этот слой кэширует отрисованное представление виджета и перерисовывает его только при необходимости.
Например, если есть дерево виджетов с несколькими дочерними виджетами, некоторые из которых анимированы, без RepaintBoundary любое изменение анимации приведёт к перерисовке всего дерева, даже если изменения затрагивают только малую его часть. Это может привести к проблемам производительности, особенно если дерево виджетов сложное.
Обернув анимированные виджеты в RepaintBoundary, можно предотвратить ненужную перерисовку. Теперь только виджет RepaintBoundary и его дочерние элементы, которые изменились, будут перерисованы, в то время как остальное дерево виджетов останется кэшированным и неизмененным

### Анимация

Для анализа производительности отрисовки были использованы разные способы.

Устройство: **Samsung Galaxy S24**

Таким образом 


https://github.com/user-attachments/assets/79d8574a-8cc2-4e0e-a03f-4e0e3b4a71cd



https://github.com/user-attachments/assets/8bef4d20-ac38-49e6-b2cc-b73c413a8b8a



https://github.com/user-attachments/assets/3369daec-63b6-4629-b66d-186d660b8474



https://github.com/user-attachments/assets/4ca6a687-a1db-4020-86dd-984e0301ca3b



https://github.com/user-attachments/assets/b5e1c138-233f-4fef-b7fa-fe97bd1a4b92



https://github.com/user-attachments/assets/a516fb1c-8bea-4a96-bca2-0baf6bca841b


