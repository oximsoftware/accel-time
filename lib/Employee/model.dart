class Head {
  String? designation;
  String? department;
  String? date;
  String? amount;
  String? eRRORMESSAGE;

  Head(
      {this.designation,
      this.department,
      this.date,
      this.amount,
      this.eRRORMESSAGE});

  Head.fromJson(Map<String, dynamic> json) {
    designation = json['Designation'];
    department = json['Department'];
    date = json['Date'];
    amount = json['Amount'].toString();
    eRRORMESSAGE = json['ERRORMESSAGE'];
  }
}

class Tail {
  String? allowance;
  String? baseRate;
  String? type;
  String? amount;
  String? monthlyPay;

  Tail(
      {this.allowance, this.baseRate, this.type, this.amount, this.monthlyPay});

  Tail.fromJson(Map<String, dynamic> json) {
    allowance = json['Allowance'];
    baseRate = json['BaseRate'];
    type = json['Type'];
    amount = json['Amount'].toString();
    monthlyPay = json['MonthlyPay'].toString();
  }
}

class ClientLeaves {
  String? employeeName;
  String? leaveName;
  String? leaveType;
  String? fromDate;
  String? toDate;
  String? noOfLeaves;
  String? reason;
  String? status;

  ClientLeaves(
      {this.employeeName,
      this.leaveName,
      this.leaveType,
      this.fromDate,
      this.toDate,
      this.noOfLeaves,
      this.reason,
      this.status});

  ClientLeaves.fromJson(Map<String, dynamic> json) {
    employeeName = json['Employee'];
    leaveName = json['LeaveName'];
    leaveType = json['Leave Type'];
    fromDate = json['From Date'];
    toDate = json['To Date'];
    noOfLeaves = json['No Of Leaves'].toString();
    reason = json['Reason'];
    status = json['Status'];
  }
}

class Leaves {
  String? leaveName;
  String? leaveType;
  String? fromDate;
  String? toDate;
  String? noOfLeaves;
  String? reason;
  String? status;

  Leaves(
      {this.leaveName,
      this.leaveType,
      this.fromDate,
      this.toDate,
      this.noOfLeaves,
      this.reason,
      this.status});

  Leaves.fromJson(Map<String, dynamic> json) {
    leaveName = json['LeaveName'];
    leaveType = json['Leave Type'];
    fromDate = json['From Date'];
    toDate = json['To Date'];
    noOfLeaves = json['No Of Leaves'].toString();
    reason = json['Reason'];
    status = json['Status'];
  }
}

class LeaveBalances {
  String? leaves;
  String? opening;
  String? credit;
  String? availed;
  String? balance;
  String? eRRORMESSAGE;

  LeaveBalances(
      {this.leaves,
      this.opening,
      this.credit,
      this.availed,
      this.balance,
      this.eRRORMESSAGE});

  LeaveBalances.fromJson(Map<String, dynamic> json) {
    leaves = json['Leaves'];
    opening = json['Opening'].toString();
    credit = json['Credit'].toString();
    availed = json['Availed'].toString();
    balance = json['Balance'].toString();
    eRRORMESSAGE = json['ERRORMESSAGE'];
  }
}

class Training {
  String? trainingSchID;
  String? trainingNumber;
  String? trainingType;
  String? fromDate;
  String? toDate;
  String? remarks;
  String? attendDate;
  String? attendanceFlag;
  String? eRRORMESSAGE;

  Training(
      {this.trainingSchID,
      this.trainingNumber,
      this.trainingType,
      this.fromDate,
      this.toDate,
      this.remarks,
      this.attendDate,
      this.attendanceFlag,
      this.eRRORMESSAGE});

  Training.fromJson(Map<String, dynamic> json) {
    trainingSchID = json['TrainingSchID'].toString();
    trainingNumber = json['TrainingNumber'];
    trainingType = json['TrainingType'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    remarks = json['Remarks'];
    attendDate = json['AttendDate'];
    attendanceFlag = json['AttendanceFlag'].toString();
    eRRORMESSAGE = json['ERRORMESSAGE'];
  }
}

class Leavemaster {
  int? value;
  String? name;

  Leavemaster({this.value, this.name});

  Leavemaster.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    name = json['Name'];
  }
}

class Claimmaster {
  int? value;
  String? name;

  Claimmaster({this.value, this.name});

  Claimmaster.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    name = json['Name'];
  }
}

class NoLeaves {
  double? noOfLeaves;
  String? eRRORMESSAGE;

  NoLeaves({this.noOfLeaves, this.eRRORMESSAGE});

  NoLeaves.fromJson(Map<String, dynamic> json) {
    noOfLeaves = json['NoOfLeaves'];
    eRRORMESSAGE = json['ERRORMESSAGE'];
  }
}

class Myclaimmodel {
  String? claimFormID;
  String? claimDate;
  String? claimNumber;
  String? amount;
  String? status;

  Myclaimmodel(
      {this.claimFormID,
      this.claimDate,
      this.claimNumber,
      this.amount,
      this.status});

  Myclaimmodel.fromJson(Map<String, dynamic> json) {
    claimFormID = json['ClaimFormID'].toString();
    claimDate = json['ClaimDate'];
    claimNumber = json['ClaimNumber'];
    amount = json['Amount'].toString();
    status = json['Status'];
  }
}

class MyclaimDetailmodel {
  String? claimFormID;
  String? claimID;
  String? amount;
  String? reason;
  String? claim;
  String? status;
  String? statusText;

  MyclaimDetailmodel(
      {this.claimFormID,
      this.claimID,
      this.amount,
      this.reason,
      this.claim,
      this.status,
      this.statusText});

  MyclaimDetailmodel.fromJson(Map<String, dynamic> json) {
    claimFormID = json['ClaimFormID'].toString();
    claimID = json['ClaimID'].toString();
    amount = json['Amount'].toString();
    reason = json['Reason'];
    claim = json['Claim'];
    status = json['Status'].toString();
    statusText = json['StatusText'];
  }
}

class ScheduleModel {
  String? client;
  String? location;
  String? scheduleDate;
  String? clientID;
  String? locationID;
  String? departID;
  String? shiftID;
  String? desigID;
  String? resourceScheduleID;
  String? shiftFromTime;
  String? shiftToTime;
  String? inTime;
  String? outTime;

  ScheduleModel(
      {this.client,
      this.location,
      this.scheduleDate,
      this.clientID,
      this.locationID,
      this.departID,
      this.shiftID,
      this.desigID,
      this.resourceScheduleID,
      this.shiftFromTime,
      this.shiftToTime,
      this.inTime,
      this.outTime});

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    client = json['Client'];
    location = json['Location'];
    scheduleDate = json['ScheduleDate'];
    clientID = json['ClientID'].toString();
    locationID = json['LocationID'].toString();
    departID = json['DepartID'].toString();
    shiftID = json['ShiftID'].toString();
    desigID = json['DesigID'].toString();
    resourceScheduleID = json['ResourceScheduleID'].toString();
    shiftFromTime = json['ShiftFromTime'];
    shiftToTime = json['ShiftToTime'];
    inTime = json['InTime'];
    outTime = json['OutTime'];
  }
}

class Timesheet {
  String? attendID;
  String? client;
  String? location;
  String? attendanceDate;
  String? status;

  Timesheet(
      {this.attendID,
      this.client,
      this.location,
      this.attendanceDate,
      this.status});

  Timesheet.fromJson(Map<String, dynamic> json) {
    attendID = json['AttendID'].toString();
    client = json['Client'];
    location = json['Location'];
    attendanceDate = json['AttendanceDate'];
    status = json['Status'];
  }
}

class TimesheetDetail {
  String? attendID;
  String? empID;
  String? employee;
  String? slNo;
  String? mile;
  String? inTime;
  String? outTime;

  TimesheetDetail(
      {this.attendID,
      this.empID,
      this.employee,
      this.slNo,
      this.mile,
      this.inTime,
      this.outTime});

  TimesheetDetail.fromJson(Map<String, dynamic> json) {
    attendID = json['AttendID'].toString();
    empID = json['EmpID'].toString();
    employee = json['Employee'];
    slNo = json['SlNo'].toString();
    mile = json['Mile'];
    inTime = json['InTime'];
    outTime = json['OutTime'];
  }
}

class Location {
  String? locationName;
  String? address;
  String? zIPCode;
  String? phoneNumber;
  String? email;
  String? locationID;
  String? eRRORMESSAGE;

  Location(
      {this.locationName,
      this.address,
      this.zIPCode,
      this.phoneNumber,
      this.email,
      this.locationID,
      this.eRRORMESSAGE});

  Location.fromJson(Map<String, dynamic> json) {
    locationName = json['LocationName'];
    address = json['Address'];
    zIPCode = json['ZIPCode'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    locationID = json['LocationID'].toString();
    eRRORMESSAGE = json['ERRORMESSAGE'];
  }
}

class Incidents {
  int? incidentID;
  String? client;
  String? location;
  String? scheduleDate;
  String? department;
  String? designation;
  String? shift;
  String? fromTime;
  String? toTime;
  int? resourceScheduleID;
  int? clientID;
  int? locationID;
  int? departID;
  int? shiftID;
  int? desigID;
  int? empID;

  Incidents(
      {this.incidentID,
      this.client,
      this.location,
      this.scheduleDate,
      this.department,
      this.designation,
      this.shift,
      this.fromTime,
      this.toTime,
      this.resourceScheduleID,
      this.clientID,
      this.locationID,
      this.departID,
      this.shiftID,
      this.desigID,
      this.empID});

  Incidents.fromJson(Map<String, dynamic> json) {
    incidentID = json['IncidentID'];
    client = json['Client'];
    location = json['Location'];
    scheduleDate = json['ScheduleDate'];
    department = json['Department'];
    designation = json['Designation'];
    shift = json['Shift'];
    fromTime = json['FromTime'];
    toTime = json['ToTime'];
    resourceScheduleID = json['ResourceScheduleID'];
    clientID = json['ClientID'];
    locationID = json['LocationID'];
    departID = json['DepartID'];
    shiftID = json['ShiftID'];
    desigID = json['DesigID'];
    empID = json['EmpID'];
  }
}
