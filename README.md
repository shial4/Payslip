<p align="center">
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/api-template">
        <img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-4.1-brightgreen.svg" alt="Swift 4.1">
    </a>
</p>

Server starting on http://localhost:8080

Endpoint fort Payslip calculation based on input:

Example input
```JSON
{
"employee": {
"name": "R2-D2",
"age": "adult",
"casual": true
},
"wageLevels": {
"1": "12.34",
"3": "14.12"
},
"shifts": [
{
"start": "2019-06-27T12:00:00",
"end": "2019-06-27T23:15:00",
"wageLevel": "1",
"breakStart": "2019-06-27T17:30:00",
"breakDurationMinutes": "45"
},
{
"start": "2019-06-28T12:00:00",
"end": "2019-06-28T16:15:00",
"wageLevel": "1"
},
{
"start": "2019-06-29T11:00:00",
"end": "2019-06-29T18:30:00",
"wageLevel": "1"
},
{
"start": "2019-06-30T12:00:00",
"end": "2019-06-30T21:15:00",
"wageLevel": "1",
"breakStart": "2019-06-30T14:30:00",
"breakDurationMinutes": "30"
}
]
}
```

**POST** for http://localhost:8080/payslip

Example output: 
```JSON
{
"totalEarnings": 22952.400000000001,
"totalWorkHours": 25.75,
"shifts": [
{
"workOvertimeRate": 0,
"workAtEveningRate": 0,
"workOvertimeMinutes": 0,
"workAtEveningMinutes": 315,
"workRate": 0,
"total": 7774.1999999999998,
"workMinutes": 315
},
{
"workOvertimeRate": 0,
"workAtEveningRate": 0,
"workOvertimeMinutes": 0,
"workAtEveningMinutes": 0,
"workRate": 0,
"total": 3146.6999999999998,
"workMinutes": 255
},
{
"workOvertimeRate": 0,
"workAtEveningRate": 0,
"workOvertimeMinutes": 0,
"workAtEveningMinutes": 0,
"workRate": 0,
"total": 5553,
"workMinutes": 450
},
{
"workOvertimeRate": 0,
"workAtEveningRate": 0,
"workOvertimeMinutes": 0,
"workAtEveningMinutes": 0,
"workRate": 0,
"total": 6478.5,
"workMinutes": 525
}
],
"eveningWorkHours": 5.25,
"overtimeWorkHours": 0
}
```
