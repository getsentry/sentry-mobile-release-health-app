import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/state/app_state.dart';
import 'release_card.dart';
import 'release_health_view_model.dart';

class ReleaseHealth extends StatefulWidget {
  const ReleaseHealth({Key key}) : super(key: key);

  @override
  _ReleaseHealthState createState() => _ReleaseHealthState();
}

class _ReleaseHealthState extends State<ReleaseHealth> {
  int _index = 0;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReleaseHealthViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => ReleaseHealthViewModel.fromStore(store),
    );
  }

  Widget _content(ReleaseHealthViewModel viewModel) {
    if (viewModel.loading || viewModel.releases.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Color(0xff81B4FE)),
        ),
      );
    } else {

      WidgetsBinding.instance.addPostFrameCallback( ( Duration duration ) {
        if (viewModel.loading) {
          refreshKey.currentState.show();
        } else {
          refreshKey.currentState.deactivate();
        }
      });

      return RefreshIndicator(
        key: refreshKey,
        backgroundColor: Colors.white,
        color: Color(0xff81B4FE),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: viewModel.releases.length,
                    controller: PageController(viewportFraction: 0.85),
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    itemBuilder: (context, index) {
                      return ReleaseCard(
                          project: viewModel.project,
                          release: viewModel.releases[index],
                      );
                    },
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    HealthDivider(
                      onSeeAll: () {},
                      title: 'Charts',
                      paddingBottom: 10,
                    ),
                    ChartRow(
                        title: 'Issues',
                        total: viewModel.releases[_index].issues,
                        change: 3.6), // TODO: api
                    ChartRow(
                        title: 'Crashes',
                        total: viewModel.releases[_index].crashes,
                        change: -4.2), // TODO: api
                    HealthDivider(
                      onSeeAll: () {},
                      title: 'Statistics',
                      paddingBottom: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        HealthCard(
                            title: 'Crash Free Users',
                            value: viewModel.releases[_index].crashFreeUsers,
                            change: 0.04), // TODO: api
                        HealthCard(
                            title: 'Crash Free Sessions',
                            value: viewModel.releases[_index].crashFreeSessions,
                            change: -0.01), // TODO: api
                      ],
                    )
                  ],
                ),
              ),
              Row(children: [
                Expanded(
                    child: Container(
                      child: Echarts(
                        option: '''
                {
                  isGroupedByDate: true,
                  showTimeInTooltip: true,
                  tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'none',
                    },
                    position: ['50%',0]
                  },
                  xAxis: [{
                    type: 'time',
                    show: false

                  }],
                  yAxis: [{
                    type: 'value',
                    show: false
                  }],
                  grid: {
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0
                  },
                  series: [{
                    name: 'Crashed',
                    showSymbol: false,
                    symbolSize: 6,
                    data: [[1596067200000,0],[1596070800000,0],[1596074400000,2],[1596078000000,1],[1596081600000,2],[1596085200000,0],[1596088800000,1],[1596092400000,0],[1596096000000,1],[1596099600000,0],[1596103200000,1],[1596106800000,0],[1596110400000,1],[1596114000000,0],[1596117600000,1],[1596121200000,1],[1596124800000,1],[1596128400000,1],[1596132000000,0],[1596135600000,0],[1596139200000,0],[1596142800000,1],[1596146400000,0],[1596150000000,1],[1596153600000,3],[1596157200000,1],[1596160800000,1],[1596164400000,0],[1596168000000,2],[1596171600000,1],[1596175200000,1],[1596178800000,0],[1596182400000,0],[1596186000000,1],[1596189600000,1],[1596193200000,1],[1596196800000,1],[1596200400000,1],[1596204000000,0],[1596207600000,0],[1596211200000,3],[1596214800000,2],[1596218400000,4],[1596222000000,0],[1596225600000,0],[1596229200000,1],[1596232800000,0],[1596236400000,1],[1596240000000,2],[1596243600000,2],[1596247200000,1],[1596250800000,0],[1596254400000,2],[1596258000000,1],[1596261600000,0],[1596265200000,1],[1596268800000,0],[1596272400000,0],[1596276000000,0],[1596279600000,0],[1596283200000,1],[1596286800000,0],[1596290400000,1],[1596294000000,0],[1596297600000,0],[1596301200000,1],[1596304800000,1],[1596308400000,1],[1596312000000,0],[1596315600000,0],[1596319200000,5],[1596322800000,2],[1596326400000,0],[1596330000000,1],[1596333600000,1],[1596337200000,1],[1596340800000,0],[1596344400000,0],[1596348000000,1],[1596351600000,0],[1596355200000,2],[1596358800000,0],[1596362400000,1],[1596366000000,1],[1596369600000,0],[1596373200000,0],[1596376800000,1],[1596380400000,1],[1596384000000,0],[1596387600000,0],[1596391200000,1],[1596394800000,0],[1596398400000,1],[1596402000000,1],[1596405600000,2],[1596409200000,2],[1596412800000,0],[1596416400000,0],[1596420000000,0],[1596423600000,1],[1596427200000,1],[1596430800000,2],[1596434400000,3],[1596438000000,3],[1596441600000,1],[1596445200000,1],[1596448800000,2],[1596452400000,1],[1596456000000,2],[1596459600000,0],[1596463200000,0],[1596466800000,4],[1596470400000,0],[1596474000000,0],[1596477600000,0],[1596481200000,0],[1596484800000,3],[1596488400000,1],[1596492000000,1],[1596495600000,2],[1596499200000,0],[1596502800000,0],[1596506400000,0],[1596510000000,0],[1596513600000,2],[1596517200000,0],[1596520800000,0],[1596524400000,0],[1596528000000,0],[1596531600000,0],[1596535200000,0],[1596538800000,0],[1596542400000,0],[1596546000000,1]],
                    type: 'line',
                    stack: 'area',
                    color: '#444674',
                    areaStyle: {
                      color: '#444674',
                      opacity: 1
                    },
                    lineStyle: {
                      opacity: 0,
                      width: 0.4
                    }
                  },
                  {
                    name: 'Abnormal',
                    showSymbol: false,
                    symbolSize: 6,
                    data: [[1596067200000,1],[1596070800000,1],[1596074400000,0],[1596078000000,3],[1596081600000,0],[1596085200000,3],[1596088800000,3],[1596092400000,2],[1596096000000,1],[1596099600000,1],[1596103200000,0],[1596106800000,0],[1596110400000,0],[1596114000000,3],[1596117600000,1],[1596121200000,4],[1596124800000,9],[1596128400000,7],[1596132000000,3],[1596135600000,4],[1596139200000,2],[1596142800000,8],[1596146400000,3],[1596150000000,5],[1596153600000,2],[1596157200000,3],[1596160800000,7],[1596164400000,2],[1596168000000,1],[1596171600000,1],[1596175200000,1],[1596178800000,4],[1596182400000,3],[1596186000000,1],[1596189600000,0],[1596193200000,2],[1596196800000,4],[1596200400000,4],[1596204000000,2],[1596207600000,5],[1596211200000,3],[1596214800000,10],[1596218400000,7],[1596222000000,5],[1596225600000,8],[1596229200000,4],[1596232800000,10],[1596236400000,8],[1596240000000,6],[1596243600000,7],[1596247200000,7],[1596250800000,9],[1596254400000,5],[1596258000000,4],[1596261600000,1],[1596265200000,3],[1596268800000,6],[1596272400000,3],[1596276000000,4],[1596279600000,1],[1596283200000,2],[1596286800000,2],[1596290400000,7],[1596294000000,3],[1596297600000,8],[1596301200000,12],[1596304800000,5],[1596308400000,8],[1596312000000,3],[1596315600000,5],[1596319200000,4],[1596322800000,5],[1596326400000,4],[1596330000000,4],[1596333600000,5],[1596337200000,3],[1596340800000,3],[1596344400000,0],[1596348000000,5],[1596351600000,2],[1596355200000,2],[1596358800000,0],[1596362400000,3],[1596366000000,0],[1596369600000,4],[1596373200000,4],[1596376800000,3],[1596380400000,4],[1596384000000,6],[1596387600000,8],[1596391200000,3],[1596394800000,3],[1596398400000,4],[1596402000000,4],[1596405600000,5],[1596409200000,4],[1596412800000,3],[1596416400000,7],[1596420000000,8],[1596423600000,8],[1596427200000,2],[1596430800000,1],[1596434400000,1],[1596438000000,0],[1596441600000,0],[1596445200000,3],[1596448800000,1],[1596452400000,1],[1596456000000,4],[1596459600000,2],[1596463200000,7],[1596466800000,6],[1596470400000,6],[1596474000000,8],[1596477600000,9],[1596481200000,7],[1596484800000,7],[1596488400000,4],[1596492000000,6],[1596495600000,4],[1596499200000,9],[1596502800000,3],[1596506400000,6],[1596510000000,2],[1596513600000,2],[1596517200000,1],[1596520800000,1],[1596524400000,0],[1596528000000,3],[1596531600000,0],[1596535200000,3],[1596538800000,1],[1596542400000,1],[1596546000000,3]],
                    type: 'line',
                    stack: 'area',
                    color: '#a35488',
                    areaStyle: {
                      color: '#a35488',
                      opacity: 1
                    },
                    lineStyle: {
                      opacity: 0,
                      width: 0.4
                    }
                  },
                  {
                    name: 'Errored',
                    showSymbol: false,
                    symbolSize: 6,
                    data: [[1596067200000,0],[1596070800000,0],[1596074400000,0],[1596078000000,0],[1596081600000,0],[1596085200000,0],[1596088800000,0],[1596092400000,0],[1596096000000,0],[1596099600000,0],[1596103200000,0],[1596106800000,0],[1596110400000,0],[1596114000000,0],[1596117600000,0],[1596121200000,0],[1596124800000,0],[1596128400000,0],[1596132000000,0],[1596135600000,0],[1596139200000,0],[1596142800000,0],[1596146400000,0],[1596150000000,0],[1596153600000,0],[1596157200000,0],[1596160800000,0],[1596164400000,0],[1596168000000,0],[1596171600000,0],[1596175200000,0],[1596178800000,0],[1596182400000,0],[1596186000000,0],[1596189600000,0],[1596193200000,0],[1596196800000,0],[1596200400000,0],[1596204000000,0],[1596207600000,0],[1596211200000,0],[1596214800000,0],[1596218400000,0],[1596222000000,0],[1596225600000,0],[1596229200000,0],[1596232800000,0],[1596236400000,0],[1596240000000,0],[1596243600000,0],[1596247200000,0],[1596250800000,0],[1596254400000,0],[1596258000000,0],[1596261600000,0],[1596265200000,0],[1596268800000,0],[1596272400000,0],[1596276000000,0],[1596279600000,0],[1596283200000,0],[1596286800000,0],[1596290400000,0],[1596294000000,0],[1596297600000,0],[1596301200000,0],[1596304800000,0],[1596308400000,0],[1596312000000,0],[1596315600000,0],[1596319200000,0],[1596322800000,0],[1596326400000,0],[1596330000000,0],[1596333600000,0],[1596337200000,0],[1596340800000,0],[1596344400000,0],[1596348000000,0],[1596351600000,0],[1596355200000,0],[1596358800000,0],[1596362400000,0],[1596366000000,0],[1596369600000,0],[1596373200000,0],[1596376800000,0],[1596380400000,0],[1596384000000,0],[1596387600000,0],[1596391200000,0],[1596394800000,0],[1596398400000,0],[1596402000000,0],[1596405600000,0],[1596409200000,0],[1596412800000,0],[1596416400000,0],[1596420000000,0],[1596423600000,0],[1596427200000,0],[1596430800000,0],[1596434400000,0],[1596438000000,0],[1596441600000,0],[1596445200000,0],[1596448800000,0],[1596452400000,0],[1596456000000,0],[1596459600000,0],[1596463200000,0],[1596466800000,0],[1596470400000,0],[1596474000000,0],[1596477600000,0],[1596481200000,0],[1596484800000,0],[1596488400000,0],[1596492000000,0],[1596495600000,0],[1596499200000,0],[1596502800000,0],[1596506400000,0],[1596510000000,0],[1596513600000,0],[1596517200000,0],[1596520800000,0],[1596524400000,0],[1596528000000,0],[1596531600000,0],[1596535200000,0],[1596538800000,0],[1596542400000,0],[1596546000000,0]],
                    type: 'line',
                    stack: 'area',
                    color: '#ef7061',
                    areaStyle: {
                      color: '#ef7061',
                      opacity: 1
                    },
                    lineStyle: {
                      opacity: 0,
                      width: 0.4
                    }
                  },
                  {
                    name: 'Healthy',
                    showSymbol: false,
                    symbolSize: 6,
                    data: [[1596067200000,13],[1596070800000,27],[1596074400000,23],[1596078000000,52],[1596081600000,17],[1596085200000,8],[1596088800000,20],[1596092400000,28],[1596096000000,8],[1596099600000,22],[1596103200000,20],[1596106800000,27],[1596110400000,26],[1596114000000,45],[1596117600000,42],[1596121200000,32],[1596124800000,45],[1596128400000,48],[1596132000000,69],[1596135600000,95],[1596139200000,80],[1596142800000,70],[1596146400000,64],[1596150000000,83],[1596153600000,61],[1596157200000,79],[1596160800000,76],[1596164400000,52],[1596168000000,50],[1596171600000,43],[1596175200000,46],[1596178800000,45],[1596182400000,41],[1596186000000,43],[1596189600000,65],[1596193200000,54],[1596196800000,65],[1596200400000,57],[1596204000000,80],[1596207600000,60],[1596211200000,80],[1596214800000,69],[1596218400000,66],[1596222000000,71],[1596225600000,78],[1596229200000,65],[1596232800000,91],[1596236400000,77],[1596240000000,84],[1596243600000,86],[1596247200000,67],[1596250800000,51],[1596254400000,48],[1596258000000,56],[1596261600000,48],[1596265200000,56],[1596268800000,41],[1596272400000,51],[1596276000000,31],[1596279600000,47],[1596283200000,53],[1596286800000,65],[1596290400000,57],[1596294000000,97],[1596297600000,123],[1596301200000,73],[1596304800000,65],[1596308400000,89],[1596312000000,109],[1596315600000,58],[1596319200000,66],[1596322800000,71],[1596326400000,107],[1596330000000,103],[1596333600000,105],[1596337200000,69],[1596340800000,65],[1596344400000,45],[1596348000000,39],[1596351600000,40],[1596355200000,44],[1596358800000,54],[1596362400000,32],[1596366000000,46],[1596369600000,55],[1596373200000,69],[1596376800000,62],[1596380400000,90],[1596384000000,88],[1596387600000,78],[1596391200000,67],[1596394800000,70],[1596398400000,72],[1596402000000,101],[1596405600000,73],[1596409200000,54],[1596412800000,85],[1596416400000,54],[1596420000000,87],[1596423600000,45],[1596427200000,61],[1596430800000,43],[1596434400000,40],[1596438000000,38],[1596441600000,36],[1596445200000,45],[1596448800000,40],[1596452400000,38],[1596456000000,61],[1596459600000,72],[1596463200000,76],[1596466800000,69],[1596470400000,83],[1596474000000,120],[1596477600000,115],[1596481200000,109],[1596484800000,98],[1596488400000,97],[1596492000000,75],[1596495600000,79],[1596499200000,62],[1596502800000,76],[1596506400000,63],[1596510000000,63],[1596513600000,68],[1596517200000,68],[1596520800000,57],[1596524400000,28],[1596528000000,30],[1596531600000,52],[1596535200000,41],[1596538800000,46],[1596542400000,57],[1596546000000,50]],
                    type: 'line',
                    smooth: true,
                    stack: 'area',
                    color: '#FFC227',
                    areaStyle: {
                      color: '#FFC227',
                      opacity: 1
                    },
                    lineStyle: {
                      opacity: 0,
                      width: 0.4
                    }
                  }]
                }
              ''',
                      ),
                      height: 120,
                    ))
              ])
            ],
          ),
        ),
        onRefresh: () => Future.delayed(
          Duration(microseconds: 100),
          () { viewModel.fetchReleases(); }
        ),
      );
    }
  }
}

class HealthDivider extends StatelessWidget {
  HealthDivider(
      {@required this.title,
      @required this.onSeeAll,
      @required this.paddingBottom});

  final String title;
  final void Function() onSeeAll;
  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFB9C1D9),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          MaterialButton(
            minWidth: 0,
            padding: EdgeInsets.zero,
            onPressed: onSeeAll,
            child: Text(
              'See All',
              style: TextStyle(
                color: Color(0xFF81B4FE),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HealthCard extends StatelessWidget {
  HealthCard(
      {@required this.title, this.value, @required this.change});

  final String title;
  final double value;
  final double change;

  final warningThreshold = 99.5;
  final dangerThreshold = 98;

  Color getColor() {
    return value == null
        ? Color(0xFFB9C1D9)
        : value > warningThreshold
          ? Color(0xFF23B480)
          : value > dangerThreshold ? Color(0xFFFFC227) : Color(0xFFEE6855);
  }

  String getIcon() {
    return value == null
      ? null
      : value > warningThreshold
        ? 'assets/status-green.png'
        : value > dangerThreshold
            ? 'assets/status-orange.png'
            : 'assets/status-red.png';
  }

  String getTrendSign() {
    return change > 0 ? '+' : '';
  }

  String getTrendIcon() {
    return change == 0
        ? null
        : change > 0
            ? 'assets/trend-up-green.png'
            : 'assets/trend-down-red.png';
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 3,
      shadowColor: Color(0x99FFFFFF),
      margin: EdgeInsets.only(left: 7, right: 7, top: 1, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: getIcon() != null ? Image.asset(getIcon(), height: 50) : SizedBox(height: 50),
          ),
          Text(
            value != null ? value.toString() + '%' : '--',
            style: TextStyle(
              color: getColor(),
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF14223B),
                  fontSize: 14,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  change != null ? getTrendSign() + change.toString() + '%' : '--',
                  style: TextStyle(
                    color: Color(0xFFB9C1D9),
                    fontSize: 13,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: getTrendIcon() != null ? Image.asset(getTrendIcon(), height: 8) : Spacer(),
                )
              ])),
        ],
      ),
    ));
  }
}

class ChartRow extends StatelessWidget {
  ChartRow({@required this.title, @required this.total, @required this.change});

  final String title;
  final int total;
  final double change;

  String getTrendSign() {
    return change > 0 ? '+' : '';
  }

  String getTrendIcon() {
    return change > 0
        ? 'assets/trend-up-red.png'
        : 'assets/trend-down-green.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 22),
        margin: EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0x33B9C1D9))),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(title,
                      style: TextStyle(
                        color: Color(0xFF18181A),
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ))),
              Text('Last 24 hours',
                  style: TextStyle(
                    color: Color(0xFFB9C1D9),
                    fontSize: 14,
                  ))
            ],
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Echarts(
              option: '''
                {
                  isGroupedByDate: true,
                  xAxis: [{
                    type: 'time',
                    show: false

                  }],
                  yAxis: [{
                    type: 'value',
                    show: false
                  }],
                  grid: {
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0
                  },
                  series: [
                  {
                    name: 'Healthy',
                    showSymbol: false,
                    symbolSize: 6,
                    data: ''' +
                  (Random().nextInt(100) > 50
                      ? '''[[1596528000000,45],[1596531600000,32],[1596535200000,42],[1596538800000,36],[1596542400000,32],[1596546000000,32]],'''
                      : '''[[1596528000000,35],[1596531600000,32],[1596535200000,42],[1596538800000,6],[1596542400000,32],[1596546000000,82]],''') +
                  '''
                    type: 'line',
                    smooth: true,
                    stack: 'area',
                    areaStyle: {
                      color: {
                          type: 'linear',
                          x: 0,
                          y: 0,
                          x2: 0,
                          y2: 1,
                          colorStops: [{
                              offset: 0, color: 'rgba(129, 180, 254, 0.40)'
                          }, {
                              offset: 1, color: 'rgba(129, 180, 254, 0)'
                          }],
                          global: false
                      },
                      opacity: 1
                    },
                    lineStyle: {
                      opacity: 1,
                      width: 2,
                      color: '#81B4FE'
                    }
                  }]
                }
              ''',
            ),
            height: 35,
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(total.toString(),
                      style: TextStyle(
                        color: Color(0xFF18181A),
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ))),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(getTrendSign() + change.toString() + '%',
                    style: TextStyle(
                      color: Color(0xFFB9C1D9),
                      fontSize: 14,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: Image.asset(getTrendIcon(), height: 8),
                )
              ])
            ],
          ),
        ]));
  }
}
