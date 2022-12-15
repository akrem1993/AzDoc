function SetRowCell(boundData, colfield, value) {
    let a = '';

    var rowData = $('.jqx-grid').jqxGrid('getrowdata', boundData);

    if (rowData.ExecutorControlStatus === false)
        a = 'unread';

    if (rowData.ExecutionTimeout == 3 || rowData.ExecutionTimeout == 2)
        a += ' docTimeout3';

    if (rowData.ExecutionTimeout == 1)
        a += ' docTimeout1';

    if (rowData.ExecutionTimeout <= 0 && rowData.ExecutionTimeout != null)
        a += ' docTimeout0';

    return a;
}