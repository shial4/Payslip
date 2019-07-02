<p align="center">
    <a href="https://travis-ci.com/shial4/Payslip">
        <img src="https://travis-ci.com/shial4/Payslip.svg?branch=master" alt="TravisCI" />
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/api-template">
        <img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
</p>

Server starting on http://localhost:8080

## Request Header
```
Content-Type application/json
```

## Request Input

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

## Request Response

Shifts may be identfy by `startTime`.

Example output: 
```JSON
{
    "totalEarnings": 22952.400000000001,
    "totalWorkHours": 25.75,
    "eveningWorkHours": 5.25,
    "overtimeWorkHours": 0,
    "shifts": [
        {
            "workOvertimeRate": 0,
            "workAtEveningRate": 0,
            "workOvertimeMinutes": 0,
            "workAtEveningMinutes": 315,
            "workRate": 0,
            "total": 7774.1999999999998,
            "workMinutes": 315,
            "startTime": "2019-06-27T12:00:00"
        },
        {
            "workOvertimeRate": 0,
            "workAtEveningRate": 0,
            "workOvertimeMinutes": 0,
            "workAtEveningMinutes": 0,
            "workRate": 0,
            "total": 3146.6999999999998,
            "workMinutes": 255,
            "startTime": "2019-06-28T12:00:00"
        },
        {
            "workOvertimeRate": 0,
            "workAtEveningRate": 0,
            "workOvertimeMinutes": 0,
            "workAtEveningMinutes": 0,
            "workRate": 0,
            "total": 5553,
            "workMinutes": 450,
            "startTime": "2019-06-29T11:00:00"
        },
        {
            "workOvertimeRate": 0,
            "workAtEveningRate": 0,
            "workOvertimeMinutes": 0,
            "workAtEveningMinutes": 0,
            "workRate": 0,
            "total": 6478.5,
            "workMinutes": 525,
            "startTime": "2019-06-30T12:00:00"
        }
    ]
}
```
