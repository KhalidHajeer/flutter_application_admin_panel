import 'package:flutter/material.dart';
import 'package:flutter_application_admin_panel/users_screen/componenets/users_list_widget.dart';
import 'package:provider/provider.dart';

import '../../../managers/manager_users.dart';
import '../../../models/model_user.dart';

class CustomerTabView extends StatefulWidget {
  const CustomerTabView({Key? key}) : super(key: key);

  @override
  _CustomerTabViewState createState() => _CustomerTabViewState();
}

class _CustomerTabViewState extends State<CustomerTabView> {
  @override
  void initState() {
    ManagerUsers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ManagerUsers manager = Provider.of<ManagerUsers>(context);

    List<ModelUser> userList = manager.userList;
    List<ModelUser> foundUsers = manager.foundUsers;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
/* -------------------------------------------------------------------------- */
/*                              Search Text Form                              */
/* -------------------------------------------------------------------------- */
              child: TextFormField(
                controller: manager.controllerSearch,
                onChanged: (searchController) {
                  manager.runFilter(userList, searchController);
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.search),
                  hintText: 'search',
                  suffixIcon: IconButton(
                    onPressed: (() {
                      setState(() {
                        manager.controllerSearch.text = '';
                        manager.foundUsers.clear();
                      });
                    }),
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
/* ----------------------------------- end ---------------------------------- */
            Expanded(
                child: foundUsers.isNotEmpty
                    ? UsersListWidget(
                        list: foundUsers,
                      )
                    : UsersListWidget(
                        list: userList,
                      )),
          ],
        ),
      ),
    );
  }
}
