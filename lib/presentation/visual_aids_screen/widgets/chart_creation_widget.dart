import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:guru_ai/theme/app_theme.dart';
import 'package:guru_ai/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

class ChartCreationWidget extends StatefulWidget {
  const ChartCreationWidget({Key? key}) : super(key: key);

  @override
  State<ChartCreationWidget> createState() => _ChartCreationWidgetState();
}

class _ChartCreationWidgetState extends State<ChartCreationWidget> {
  String _selectedChartType = 'Bar Chart';
  final List<String> _chartTypes = ['Bar Chart', 'Pie Chart', 'Line Graph'];

  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _labelControllers = [];
  final List<TextEditingController> _valueControllers = [];

  int _dataPoints = 3;
  bool _showPreview = false;

  final List<Map<String, dynamic>> _mockChartData = [
    {
      "type": "Bar Chart",
      "title": "Student Performance",
      "data": [
        {"label": "Math", "value": 85.0},
        {"label": "Science", "value": 92.0},
        {"label": "English", "value": 78.0},
        {"label": "History", "value": 88.0},
      ],
    },
    {
      "type": "Pie Chart",
      "title": "Class Activities",
      "data": [
        {"label": "Reading", "value": 30.0},
        {"label": "Writing", "value": 25.0},
        {"label": "Discussion", "value": 20.0},
        {"label": "Projects", "value": 25.0},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _labelControllers.clear();
    _valueControllers.clear();

    for (int i = 0; i < _dataPoints; i++) {
      _labelControllers.add(TextEditingController());
      _valueControllers.add(TextEditingController());
    }
  }

  void _updateDataPoints(int newCount) {
    setState(() {
      _dataPoints = newCount;
      _initializeControllers();
    });
  }

  void _generateChart() {
    if (_titleController.text.trim().isEmpty) return;

    bool hasValidData = false;
    for (int i = 0; i < _dataPoints; i++) {
      if (_labelControllers[i].text.trim().isNotEmpty &&
          _valueControllers[i].text.trim().isNotEmpty) {
        hasValidData = true;
        break;
      }
    }

    if (hasValidData) {
      setState(() {
        _showPreview = true;
      });
    }
  }

  List<Map<String, dynamic>> _getCurrentChartData() {
    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < _dataPoints; i++) {
      if (_labelControllers[i].text.trim().isNotEmpty &&
          _valueControllers[i].text.trim().isNotEmpty) {
        data.add({
          "label": _labelControllers[i].text.trim(),
          "value": double.tryParse(_valueControllers[i].text.trim()) ?? 0.0,
        });
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartTypeSelector(),
          SizedBox(height: 3.h),
          _buildTitleInput(),
          SizedBox(height: 3.h),
          _buildDataPointsSelector(),
          SizedBox(height: 3.h),
          _buildDataInputSection(),
          SizedBox(height: 3.h),
          _buildGenerateButton(),
          if (_showPreview) ...[SizedBox(height: 3.h), _buildChartPreview()],
          SizedBox(height: 3.h),
          _buildQuickTemplates(),
        ],
      ),
    );
  }

  Widget _buildChartTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chart Type',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedChartType,
              isExpanded: true,
              items: _chartTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedChartType = value!;
                  _showPreview = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chart Title',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Enter chart title',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(4.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataPointsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Data Points',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [3, 4, 5, 6].map((count) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: count != 6 ? 2.w : 0),
                child: OutlinedButton(
                  onPressed: () => _updateDataPoints(count),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _dataPoints == count
                        ? AppTheme.lightTheme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          )
                        : null,
                    side: BorderSide(
                      color: _dataPoints == count
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                    ),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: _dataPoints == count
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDataInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Input',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Label',
                        style: AppTheme.lightTheme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Value',
                        style: AppTheme.lightTheme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(_dataPoints, (index) {
                return Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: index < _dataPoints - 1 ? 1 : 0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _labelControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Label ${index + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: TextField(
                          controller: _valueControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _generateChart,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'bar_chart',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Generate Chart'),
          ],
        ),
      ),
    );
  }

  Widget _buildChartPreview() {
    final chartData = _getCurrentChartData();
    if (chartData.isEmpty) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              _titleController.text.trim().isNotEmpty
                  ? _titleController.text.trim()
                  : 'Chart Preview',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 30.h,
            padding: EdgeInsets.all(4.w),
            child: _buildChart(chartData),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blackboard Instructions:',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                ...(_getDrawingInstructions().asMap().entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key + 1}. ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: CustomIconWidget(
                          iconName: 'download',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        label: Text('Export PDF'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18,
                        ),
                        label: Text('Share'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<Map<String, dynamic>> data) {
    switch (_selectedChartType) {
      case 'Bar Chart':
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY:
                data
                    .map((e) => e['value'] as double)
                    .reduce((a, b) => a > b ? a : b) *
                1.2,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < data.length) {
                      return Text(
                        data[value.toInt()]['label'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: data.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value['value'] as double,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      case 'Pie Chart':
        return PieChart(
          PieChartData(
            sections: data.asMap().entries.map((entry) {
              final colors = [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.secondary,
                AppTheme.lightTheme.colorScheme.tertiary,
                AppTheme.lightTheme.colorScheme.error,
              ];
              return PieChartSectionData(
                value: entry.value['value'] as double,
                title: '${(entry.value['value'] as double).toInt()}%',
                color: colors[entry.key % colors.length],
                radius: 60,
                titleStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          ),
        );
      default:
        return LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < data.length) {
                      return Text(
                        data[value.toInt()]['label'] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value['value'] as double,
                  );
                }).toList(),
                isCurved: true,
                color: AppTheme.lightTheme.colorScheme.primary,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        );
    }
  }

  List<String> _getDrawingInstructions() {
    switch (_selectedChartType) {
      case 'Bar Chart':
        return [
          'Draw horizontal axis and label with categories',
          'Draw vertical axis with number scale',
          'Draw bars with heights matching data values',
          'Add title at the top of the chart',
          'Label each bar clearly',
        ];
      case 'Pie Chart':
        return [
          'Draw a large circle in center of board',
          'Divide circle into sections based on percentages',
          'Color or shade each section differently',
          'Add labels and percentages for each section',
          'Include a legend if needed',
        ];
      default:
        return [
          'Draw horizontal and vertical axes',
          'Mark scale points on both axes',
          'Plot data points at correct coordinates',
          'Connect points with smooth line',
          'Add title and axis labels',
        ];
    }
  }

  Widget _buildQuickTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Templates',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.5,
          ),
          itemCount: _mockChartData.length,
          itemBuilder: (context, index) {
            final template = _mockChartData[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChartType = template['type'] as String;
                  _titleController.text = template['title'] as String;
                  final data = template['data'] as List;
                  _dataPoints = data.length;
                  _initializeControllers();

                  for (
                    int i = 0;
                    i < data.length && i < _labelControllers.length;
                    i++
                  ) {
                    _labelControllers[i].text = data[i]['label'] as String;
                    _valueControllers[i].text = (data[i]['value'] as double)
                        .toString();
                  }
                  _showPreview = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: template['type'] == 'Bar Chart'
                          ? 'bar_chart'
                          : template['type'] == 'Pie Chart'
                          ? 'pie_chart'
                          : 'show_chart',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      template['title'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      template['type'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _labelControllers) {
      controller.dispose();
    }
    for (var controller in _valueControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
