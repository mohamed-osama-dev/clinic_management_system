import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/core/widgets/app_bottom_nav.dart';

import '../cubits/dashboard_cubit.dart';
import '../cubits/dashboard_state.dart';
import '../widgets/stats_card.dart';
import '../widgets/today_schedule_list.dart';
import '../widgets/appointment_request_card.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: DoctorBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) {
        switch (i) {
          case 0: context.go(AppRoutes.doctorDashboard); break;
          case 1: context.go(AppRoutes.doctorSchedule); break;
          case 2: context.go(AppRoutes.doctorPatients); break;
          case 3: break;
        }
        setState(() => _currentNavIndex = i);
      },
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is DashboardError) {
            return Center(
              child: Text(state.message, style: AppTextStyles.bodyMedium),
            );
          }

          if (state is DashboardLoaded) {
            return _DashboardBody(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Dashboard Body ────────────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.state});

  final DashboardLoaded state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────────────────────────
        SliverToBoxAdapter(child: _DashboardHeader(state: state)),

        // ── Stats ────────────────────────────────────────────────────────────
        SliverToBoxAdapter(child: _StatsRow(stats: state.stats)),

        // ── Today Schedule ───────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingL),
            child: TodayScheduleList(
              appointments: state.todaySchedule,
              onViewAll: () {},
            ),
          ),
        ),

        // ── New Requests ─────────────────────────────────────────────────────
        if (state.newRequests.isNotEmpty)
          SliverToBoxAdapter(
            child: _NewRequestsSection(requests: state.newRequests),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.paddingXL),
        ),
      ],
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.state});

  final DashboardLoaded state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusXL),
          bottomRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingXL,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Notification icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: AppDimensions.iconL,
                ),
              ),

              // Greeting + name
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'صباح النور ☀️',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.white70),
                  ),
                  Text(
                    state.doctorName,
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                ],
              ),

              // Avatar
              Container(
                width: AppDimensions.avatarM,
                height: AppDimensions.avatarM,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: AppDimensions.iconL,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final revenue = stats.revenue >= 1000
        ? '${(stats.revenue / 1000).toStringAsFixed(1)}K'
        : stats.revenue.toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      child: Transform.translate(
        offset: const Offset(0, -24),
        child: Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.attach_money_rounded,
                value: revenue,
                label: 'الإيرادات',
                iconColor: const Color(0xFFF59E0B),
                iconBgColor: const Color(0xFFFFF8E7),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: StatsCard(
                icon: Icons.trending_up_rounded,
                value: '${stats.appointments}',
                label: 'المواعيد',
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: StatsCard(
                icon: Icons.people_outline_rounded,
                value: '${stats.todayPatients}',
                label: 'مرضى اليوم',
                iconColor: const Color(0xFF8B5CF6),
                iconBgColor: const Color(0xFFF3EEFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── New Requests Section ──────────────────────────────────────────────────────

class _NewRequestsSection extends StatelessWidget {
  const _NewRequestsSection({required this.requests});

  final List<AppointmentModel> requests;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('طلبات جديدة', style: AppTextStyles.h4),
          const SizedBox(height: AppDimensions.paddingS),
          ...requests.map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
              child: AppointmentRequestCard(
                appointment: req,
                onAccept: () =>
                    context.read<DashboardCubit>().acceptRequest(req.id),
                onReject: () =>
                    context.read<DashboardCubit>().rejectRequest(req.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
