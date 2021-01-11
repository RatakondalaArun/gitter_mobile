import 'package:flutter/material.dart';
import 'package:gitterapi/models.dart';

class GithubProfileStats extends StatelessWidget {
  final GithubStats githubStats;

  const GithubProfileStats({
    Key key,
    this.githubStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${githubStats.publicRepos} ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Repos',
                style: TextStyle(color: Colors.black45),
              )
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${githubStats.following} ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Following',
                style: TextStyle(color: Colors.black45),
              )
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${githubStats.followers} ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Followers',
                style: TextStyle(color: Colors.black45),
              )
            ],
          ),
        ),
      ],
    );
  }
}
